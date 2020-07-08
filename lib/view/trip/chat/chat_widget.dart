import 'dart:async';
import 'dart:core';
import 'package:adhara_socket_io/manager.dart';
import 'package:adhara_socket_io/options.dart';
import 'package:adhara_socket_io/socket.dart';
import 'package:backtrip/model/chat_message.dart';
import 'package:backtrip/model/trip.dart';
import 'package:backtrip/model/user.dart';
import 'package:backtrip/model/user_avatar.dart';
import 'package:backtrip/service/chat_service.dart';
import 'package:backtrip/service/user_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';

class ChatWidget extends StatefulWidget {
  final Trip _trip;

  ChatWidget(this._trip);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  Future<List<ChatMessage>> futureMessages;
  List<ChatMessage> messages;
  List<UserAvatar> usersAvatars = List<UserAvatar>();

  TextEditingController inputTextController = TextEditingController();
  ScrollController messagesScrollController = ScrollController();

  double height, width;

  SocketIOManager manager;
  SocketIO socket;
  bool isConnected = false;
  bool boolUserIsWriting = false;
  Timer searchOnStoppedTyping;
  User userThatWrite;

  @override
  void initState() {
    super.initState();
    futureMessages = getChatMessages();
    initSocket();
    getUsersAvatars();
  }

  Future<void> getUsersAvatars() async {
    List<User> userList = widget._trip.participants;
    int userListLength = userList.length;
    for(int i = 0; i < userListLength; i++) {
      CircleAvatar circleAvatar = await Components.getParticipantCircularAvatar(userList[i]);
      usersAvatars.add(UserAvatar(userList[i], circleAvatar));
    }
  }

  Future<List<ChatMessage>> getChatMessages() {
    return ChatService.getChatMessages(widget._trip.id);
  }

  initSocket() async {
    manager = SocketIOManager();

    socket = await manager.createInstance(SocketOptions(BacktripApi.path,
        nameSpace: '/',
        enableLogging: false,
        transports: [Transports.WEB_SOCKET]));

    socket.onConnect((data) => handleConnect(data));
    socket.onConnecting((data) => print("onConnecting : $data"));
    socket.onConnectTimeout((data) => print("onConnectTimeOut : $data"));
    socket.onConnectError((error) => print("onConnectError : $error"));
    socket.onDisconnect((data) => handleDisconnect(data));
    socket.onReconnect((data) => print("onReconnect : $data"));
    socket.onReconnecting((data) => print("onReconnecting : $data"));
    socket.onReconnectError((error) => print("onReconnectError : $error"));
    socket.onReconnectFailed((error) => print("onReconnectFailed : $error"));
    socket.onError((error) => print("onError : $error"));
    socket.onPing((data) => print("onPing : $data"));
    socket.onPong((data) => print("onPong : $data"));

    socket.on("message", (data) => handleNewMessage(data));
    socket.on("isWriting", (data) => userIsWriting(data));
    socket.on("stopWriting", (data) => userStopWriting());

    socket.connect();
  }

  handleConnect(data) {
    print("onConnect : $data");
    updateConnectionState();
    socket.emit("room_connection", [widget._trip.id]);
  }

  handleDisconnect(data) {
    print("onDisconnect : $data");
    updateConnectionState();
  }

  updateConnectionState() {
    socket.isConnected().then((result) => setState(() {
          isConnected = result;
        }));
  }

  handleNewMessage(data) {
    setState(() {
      messages.add(ChatMessage.fromJson(data));
    });
    scrollDown();
  }

  void userIsWriting(data) {
    userThatWrite = getUserById(widget._trip.participants, data['user_id']);
    setState(() {
      boolUserIsWriting = true;
    });
  }

  void userStopWriting() {
    setState(() {
      boolUserIsWriting = false;
    });
  }

  Widget messageArea() {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
            child: Container(
                child: FutureBuilder<List<ChatMessage>>(
                    future: futureMessages,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (messages == null) messages = snapshot.data;
                        return ListView.builder(
                          controller: messagesScrollController,
                          itemCount: messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            scrollDown();
                            return message(messages[index]);
                          },
                        );
                      } else if (snapshot.hasError) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Components.snackBar(context, snapshot.error,
                              Theme.of(context).errorColor);
                        });
                      }
                      return Center(child: CircularProgressIndicator());
                    }))));
  }

  Widget message(ChatMessage chatMessage) {
    return Padding(
        padding: EdgeInsets.fromLTRB(2, 0, 2, 5),
        child: Row(children: [
          Visibility(
              visible: isFromCurrentUser(chatMessage) ? false : true,
              child: messageCircleAvatar(chatMessage)),
          bubble(chatMessage),
          Visibility(
              visible: isFromCurrentUser(chatMessage) ? true : false,
              child: messageCircleAvatar(chatMessage)),
        ]));
  }

  Widget messageCircleAvatar(ChatMessage chatMessage) {
    User user = getUserById(widget._trip.participants, chatMessage.userId);
    CircleAvatar avatar = getCircleAvatarByUser(user);
    return Padding(
        padding: EdgeInsets.all(5),
        child: avatar);
  }

  Widget bubble(ChatMessage chatMessage) {
    return Expanded(
        child: Bubble(
            color: isFromCurrentUser(chatMessage)
                ? Color(0xFFececec)
                : Colors.white,
            padding: BubbleEdges.all(15),
            margin: BubbleEdges.only(top: 10),
            child: Text(chatMessage.message, style: TextStyle(fontSize: 17)),
            nip: isFromCurrentUser(chatMessage)
                ? BubbleNip.rightBottom
                : BubbleNip.leftBottom));
  }

  isFromCurrentUser(ChatMessage message) {
    return message.userId == BacktripApi.currentUser.id;
  }

  Widget chatInput() {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextField(
              controller: inputTextController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              maxLength: 200,
              onChanged: (text) {
                socket.emit('isWriting', [
                  BacktripApi.currentUser.id,
                  widget._trip.id,
                ]);
                detectWhenUserStopTyping();
              },
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  hintText: 'Écrivez votre message...',
                  counterText: ''
              ),
            )));
  }

  void detectWhenUserStopTyping() {
    const duration = Duration(milliseconds:800);
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel());
    }
    setState(() => searchOnStoppedTyping = new Timer(duration, () => emitStopWriting()));
  }

  void emitStopWriting() {
    socket.emit('stopWriting', [
      BacktripApi.currentUser.id,
      widget._trip.id,
    ]);
  }

  Widget statusIcon() {
    return Icon(Icons.fiber_manual_record,
        color: isConnected ? Theme.of(context).colorScheme.success : Theme.of(context).errorColor);
  }

  Widget sendButton() {
    return IconButton(
      icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
      onPressed: () {
        socket.emit('message', [
          inputTextController.text,
          widget._trip.id,
          BacktripApi.currentUser.id
        ]);
        inputTextController.text = '';
      },
    );
  }

  Widget inputArea() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(1.0, 1.0), //(x,y)
          blurRadius: 8.0,
        )
      ]),
      width: width,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Visibility(
                child: Text("${userThatWrite != null ? userThatWrite.firstName : ''} est en train d'écrire...",
                    style: new TextStyle(
                        fontSize: 15.0,
                    )),
                visible: boolUserIsWriting && userThatWrite.id != BacktripApi.currentUser.id,
              )
            ],
          ),
          Row(
            children: [
              chatInput(),
              statusIcon(),
              sendButton(),
            ],
          ),
        ],
      )
    );
  }

  scrollDown() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      messagesScrollController.animateTo(
        messagesScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.ease,
      );
    });
  }

  User getUserById(userList, userId) {
    for(User u in userList) {
      if(u.id == userId) {
        return u;
      }
    }
    return null;
  }

  CircleAvatar getCircleAvatarByUser(User user) {
    for(UserAvatar userAvatar in usersAvatars) {
      if(userAvatar.user.id == user.id) {
        return userAvatar.circleAvatar;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [messageArea(), inputArea()]));
  }

  @override
  void dispose() {
    manager.clearInstance(socket);
    super.dispose();
  }
}

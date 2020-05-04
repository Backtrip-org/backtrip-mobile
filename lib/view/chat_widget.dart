import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:adhara_socket_io/manager.dart';
import 'package:adhara_socket_io/options.dart';
import 'package:adhara_socket_io/socket.dart';
import 'package:backtrip/model/chat_message.dart';
import 'package:backtrip/model/trip.dart';
import 'package:backtrip/service/chat_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChatWidget extends StatefulWidget {
  Trip _trip;

  ChatWidget(this._trip);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  Future<List<ChatMessage>> futureMessages;
  List<ChatMessage> messages;

  TextEditingController inputTextController = TextEditingController();
  ScrollController messagesScrollController = ScrollController();
  double height, width;
  SocketIOManager manager;
  SocketIO socket;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    futureMessages = getChatMessages();
    initSocket();
  }

  Future<List<ChatMessage>> getChatMessages() {
    return ChatService.getChatMessages(widget._trip.id);
  }

  initSocket() async {
    manager = SocketIOManager();

    socket = await manager.createInstance(SocketOptions('http://10.0.2.2:5000',
        nameSpace: '/',
        enableLogging: false,
        transports: [Transports.POLLING]));

    socket.onConnect((data) => handleConnect(data));
    socket.onConnecting((data) => print("onConnecting : ${data}"));
    socket.onConnectTimeout((data) => print("onConnectTimeOut : ${data}"));
    socket.onConnectError((error) => print("onConnectError : ${error}"));
    socket.onDisconnect((data) => handleDisconnect(data));
    socket.onReconnect((data) => print("onReconnect : ${data}"));
    socket.onReconnecting((data) => print("onReconnecting : ${data}"));
    socket.onReconnectError((error) => print("onReconnectError : ${error}"));
    socket.onReconnectFailed((error) => print("onReconnectFailed : ${error}"));
    socket.onError((error) => print("onError : ${error}"));
    socket.onPing((data) => print("onPing : ${data}"));
    socket.onPong((data) => print("onPong : ${data}"));
    socket.on("message", (data) => handleNewMessage(data));

    socket.connect();
  }

  handleNewMessage(data) {
    setState(() {
      messages.add(ChatMessage(id: 0, message: data, tripId: 0, userId: 0));
    });
    scrollDown();
  }

  handleConnect(data) {
    print("onConnect : ${data}");
    updateConnectionState();
    socket.emit("room_connection", [widget._trip.id]);
  }

  handleDisconnect(data) {
    print("onDisconnect : ${data}");
    updateConnectionState();
  }

  updateConnectionState() {
    socket.isConnected().then((result) => setState(() {
          isConnected = result;
        }));
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
                            return message(index);
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Center(child: CircularProgressIndicator());
                    }))));
  }

  Widget message(int index) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2, 0, 2, 5),
        child: Row(children: [
      Padding(
          padding: EdgeInsets.all(5),
          child: Visibility(
              visible: index % 2 == 0 ? true : false,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Text('AJ',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ))),
      Expanded(
          child: Bubble(
            color: index % 2 == 0 ? Colors.white : Theme.of(context).primaryColorLight,
              padding: BubbleEdges.all(15),
              margin: BubbleEdges.only(top: 10),
              child:
                  Text(messages[index].message, style: TextStyle(fontSize: 17)),
              nip: index % 2 == 0
                  ? BubbleNip.leftBottom
                  : BubbleNip.rightBottom)),
      Padding(
          padding: EdgeInsets.all(5),
          child: Visibility(
              visible: index % 2 == 0 ? false : true,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Text('AJ',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ))),
    ]));
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
                  hintText: 'Ecrivez votre message...',
                  counterText: ''),
            )));
  }

  Widget statusIcon() {
    return Icon(Icons.signal_cellular_4_bar,
        color: isConnected ? Colors.green : Colors.red);
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
      child: Row(
        children: [
          chatInput(),
          statusIcon(),
          sendButton(),
        ],
      ),
    );
  }

  scrollDown() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      messagesScrollController.animateTo(
        messagesScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    });
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

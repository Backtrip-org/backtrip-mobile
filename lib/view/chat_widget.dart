import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:adhara_socket_io/manager.dart';
import 'package:adhara_socket_io/options.dart';
import 'package:adhara_socket_io/socket.dart';
import 'package:backtrip/model/trip.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatefulWidget {
  Trip _trip;

  ChatWidget(this._trip);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  List<String> messages = [
    "The quick brown fox jumps over the lazy dog",
    "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam.",
    "Oui en effet"
  ];
  TextEditingController inputTextController = TextEditingController();
  ScrollController messagesScrollController = ScrollController();
  double height, width;
  SocketIOManager manager;
  SocketIO socket;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();

    initSocket();
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
    print("NEW MESSAGE");
    setState(() {
      messages.add(data);
    });
  }

  handleConnect(data) {
    print("onConnect : ${data}");
    socket.isConnected().then((result) => setState(() {
          isConnected = result;
        }));
    socket.emit("room_connection", [widget._trip.id]);
  }

  handleDisconnect(data) {
    print("onDisconnect : ${data}");
    socket.isConnected().then((result) => setState(() {
      isConnected = result;
    }));
  }

  Widget messageArea() {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return message(index);
                },
              ),
            )));
  }

  Widget message(int index) {
    return Row(children: [
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
              margin: BubbleEdges.only(top: 15),
              child: Text(messages[index], style: TextStyle(fontSize: 17)),
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
    ]);
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
                  border: InputBorder.none,
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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [messageArea(), inputArea()]);
  }

  @override
  void dispose(){
    manager.clearInstance(socket);
    super.dispose();
  }
}

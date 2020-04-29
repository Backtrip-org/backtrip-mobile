import 'dart:core';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
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

  Widget sendButton() {
    return IconButton(
      icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
      onPressed: () {
        this.setState(() => messages.add(inputTextController.text));
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
}

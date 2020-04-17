import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class TimelineStepWidget extends StatefulWidget {
  @override
  _TimelineStepWidgetState createState() => _TimelineStepWidgetState();
}

class _TimelineStepWidgetState extends State<TimelineStepWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: new InkWell(
          onTap: () => navigateToStepDetail(),
          child: Card(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    children: [
                      Expanded(
                        /*1*/
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*2*/
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                "coucou",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*3*/
                    ],
                  ),
                )
              ],
            ),)
          ,
        )
    );
  }

  void navigateToStepDetail() {
//    Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => StepDetailWidget())
//    );
  }
}
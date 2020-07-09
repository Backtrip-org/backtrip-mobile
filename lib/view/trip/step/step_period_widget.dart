import 'package:backtrip/model/step/step.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';

class StepPeriodWidget extends StatelessWidget {
  final Step step;

  const StepPeriodWidget(this.step);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        date(step.startDatetime, context),
        Visibility(
            visible: step.endDateTime != null,
            child: Column(children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    material.Icons.more_vert,
                    size: 17,
                    color:
                        material.Theme.of(context).colorScheme.accentColorLight,
                  )),
              date(step.endDateTime ?? DateTime.now(), context)
            ]))
      ],
    );
  }

  Widget date(DateTime date, material.BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.only(left: 0),
          child: Row(
            children: <Widget>[
              Icon(
                material.Icons.calendar_today,
                size: 17,
                color: material.Theme.of(context).accentColor,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(DateFormat('dd MMM y', 'fr_FR').format(date),
                      style: material.Theme.of(context).textTheme.subhead)),
            ],
          )),
      SizedBox(
        width: 40,
      ),
      Container(
          child: Row(
        children: <Widget>[
          Icon(
            material.Icons.access_time,
            size: 17,
            color: material.Theme.of(context).accentColor,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(DateFormat('HH:mm', 'fr_FR').format(date),
                  style: material.Theme.of(context).textTheme.subhead))
        ],
      )),
    ]);
  }
}

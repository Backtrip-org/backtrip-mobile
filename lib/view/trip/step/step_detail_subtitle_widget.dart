import 'package:backtrip/model/step/step_transport.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StepDetailSubtitleWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final IconData actionIcon;
  final String actionLabel;
  final Function action;

  const StepDetailSubtitleWidget(this.icon, this.text, {this.actionIcon, this.action, this.actionLabel});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Icon(icon),
          SizedBox(width: 5),
          Text(text, style: Theme.of(context).textTheme.title),
          Spacer(),
          if (actionIcon != null)
            OutlineButton.icon(
                icon: Icon(
                  actionIcon,
                  size: 20,
                  color: Theme.of(context).accentColor,
                ),
                label: Text(actionLabel,
                    style: Theme.of(context).textTheme.subhead),
                onPressed: action)
        ]));
  }
}

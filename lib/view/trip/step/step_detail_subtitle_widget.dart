import 'package:backtrip/model/step/step_transport.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StepDetailSubtitleWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final IconData firstActionIcon;
  final String firstActionLabel;
  final Function firstAction;
  final IconData secondActionIcon;
  final Function secondAction;

  const StepDetailSubtitleWidget(this.icon, this.text,
      {this.firstActionIcon,
      this.firstAction,
      this.firstActionLabel,
      this.secondActionIcon,
      this.secondAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Icon(icon),
          SizedBox(width: 5),
          Text(text, style: Theme.of(context).textTheme.title),
          Spacer(),
          if (firstActionIcon != null)
            OutlineButton.icon(
                icon: Icon(
                  firstActionIcon,
                  size: 20,
                  color: Theme.of(context).accentColor,
                ),
                label: Text(firstActionLabel,
                    style: Theme.of(context).textTheme.subhead),
                onPressed: firstAction),
          if (secondActionIcon != null)
            material.IconButton(
                icon: Icon(
                  secondActionIcon,
                  size: 20,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: secondAction)
        ]));
  }
}

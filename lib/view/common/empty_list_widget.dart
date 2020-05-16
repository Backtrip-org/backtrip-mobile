import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmptyListWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const EmptyListWidget(this.title, [this.subtitle = ""]);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/empty-street.png',
                height: 200,
              ),
              Text(title,
                  style: Theme.of(context).textTheme.headline,
                  textAlign: TextAlign.center),
              SizedBox(height: 20),
              Text(subtitle,
                  style: Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.center)
            ]));
  }
}

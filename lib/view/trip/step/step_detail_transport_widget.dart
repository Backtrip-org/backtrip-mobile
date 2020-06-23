import 'package:backtrip/model/step/step_transport.dart';
import 'package:backtrip/view/trip/step/step_detail_subtitle_widget.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';

class StepDetailTransportWidget extends StatelessWidget {
  final StepTransport step;

  const StepDetailTransportWidget(this.step);

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: step.hasTransportContent(),
        child: material.Card(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StepDetailSubtitleWidget(step.icon, "Informations du transport"),
                    if (step.reservationNumber != null && step.reservationNumber != '')
                      field("Numéro de réservation", step.reservationNumber,
                          context),
                    if (step.transportNumber != null && step.transportNumber != '')
                      field(
                          "Numéro du transport", step.transportNumber, context),
                  ],
                ))));
  }

  Widget field(title, content, context) {
    return Padding(
        padding: material.EdgeInsets.only(bottom: 8),
        child: material.Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            material.Expanded(
                flex: 4,
                child: Text(title, style: Theme.of(context).textTheme.caption)),
            material.Expanded(
                flex: 6,
                child: Text(
                  content,
                ))
          ],
        ));
  }
}

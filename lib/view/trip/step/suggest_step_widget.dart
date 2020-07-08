import 'package:backtrip/model/trip.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:flutter/material.dart';

import 'create_step_widget.dart';

class SuggestStepWidget extends StatefulWidget {
  final Trip _trip;

  SuggestStepWidget(this._trip);

  @override
  _SuggestStepWidgetState createState() => _SuggestStepWidgetState();
}

class _SuggestStepWidgetState extends State<SuggestStepWidget> {
  Future<List<String>> futureSuggestions;

  @override
  void initState() {
    super.initState();
    getSuggestions();
  }

  void getSuggestions() {
    setState(() {
      futureSuggestions = TripService.suggestStep();
    });
  }

  Widget suggestions() {
    return FutureBuilder<List<String>>(
        future: futureSuggestions,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: InkWell(
                          onTap: () { navigateToStepCreation(context, snapshot.data[index]); },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Center(child: Text(snapshot.data[index], style: TextStyle(fontSize: 20),)),
                          )
                      )
                  );
                }
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  void navigateToStepCreation(BuildContext context, String suggestedStepName) {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateStepWidget(widget._trip, suggestedName: suggestedStepName)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suggestion d'activité"),
      ),
      body: suggestions(),
    );
  }

}
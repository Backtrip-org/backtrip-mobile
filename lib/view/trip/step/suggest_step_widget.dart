import 'package:backtrip/service/trip_service.dart';
import 'package:flutter/material.dart';

class SuggestStepWidget extends StatefulWidget {
  SuggestStepWidget();

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
            print(snapshot);
            return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    child: Center(child: Text(snapshot.data[index])),
                  );
                }
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        });
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
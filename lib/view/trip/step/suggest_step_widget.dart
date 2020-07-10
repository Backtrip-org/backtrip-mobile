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

  Widget suggestionBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          explicativeText(),
          SizedBox(height: 10),
          suggestions()
        ],
      ),
    );
  }

  Widget explicativeText() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Color.fromRGBO(247, 213, 21, 0.8)
          ),
          borderRadius: BorderRadius.circular(10.0),
          color: Color.fromRGBO(247, 213, 21, 0.25)
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Icon(
                Icons.info
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: Text("Vous trouverez ci-dessous une suggestion d'activités élaborée spécialement pour vous. Elle a été construite à partir de vos activités les plus fréquentes et croisées avec les profils vous ressemblant.",
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.0),
                  maxLines: 10,)
            )
          ],
        ),
      ),
    );
  }

  Widget suggestions() {
    return FutureBuilder<List<String>>(
        future: futureSuggestions,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            List<Card> cards = new List<Card>();
            for(String suggestion in snapshot.data) {
              cards.add(
                  Card(
                    child: InkWell(
                      onTap: () { navigateToStepCreation(context, suggestion); },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Center(child: Text(suggestion, style: TextStyle(fontSize: 20)),),
                      ),
                    ),
                  )
              );
            }

            return Column(
              children: cards,
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  void navigateToStepCreation(BuildContext context, String suggestedStepName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateStepWidget(widget._trip, suggestedName: suggestedStepName)
        )
    ).then((step) {
      if(step != null) {
        Navigator.pop(context, step);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Suggestion d'activité"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: suggestionBody(),
        )
    );
  }

}

import 'package:backtrip/model/place/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PlaceRatingWidget extends StatelessWidget {
  final Place place;

  const PlaceRatingWidget(this.place);

  @override
  Widget build(BuildContext context) {
    return Row(
        children:[
          ratingBar(),
          SizedBox(width: 15),
          Text(place.name)
        ]);
  }

  Widget ratingBar() {
    return RatingBarIndicator(
      rating: place.rating,
      direction: Axis.horizontal,
      itemSize: 20,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
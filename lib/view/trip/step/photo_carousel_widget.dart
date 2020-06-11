import 'dart:core';
import 'dart:io';

import 'package:backtrip/model/file.dart';
import 'package:backtrip/model/step/step_transport.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/stored_token.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:backtrip/model/step/step.dart' as step_model;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class PhotoCarouselWidget extends StatefulWidget {
  final List<File> _files;

  PhotoCarouselWidget(this._files);

  @override
  _PhotoCarouselWidgetState createState() => _PhotoCarouselWidgetState();
}

class _PhotoCarouselWidgetState extends State<PhotoCarouselWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: widget._files.length > 0 ? FutureBuilder<String>(
            future: StoredToken.getToken(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return carousel(snapshot.data);
              }
              return Text('');
            }
        ) : Text("Aucune photo pour le moment !")
    );
  }

  Widget carousel(token) {
    return CarouselSlider.builder(
        itemCount: widget._files.length,
        options: CarouselOptions(
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          enlargeCenterPage: true,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
              decoration: BoxDecoration( image: DecorationImage(image: NetworkImage(
                      '${BacktripApi.path}/file/download/${widget._files[index]
                          .id}',
                      headers: {HttpHeaders.authorizationHeader: token}), fit: BoxFit.cover)
              ));
        });
  }
}

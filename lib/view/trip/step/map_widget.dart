import 'dart:core';

import 'package:backtrip/model/step/step_transport.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:backtrip/model/step/step.dart' as step_model;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapWidget extends StatefulWidget {
  final step_model.Step _step;

  MapWidget(this._step);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  MapController _mapController = MapController();
  LatLng _startAddressLatLng;
  LatLng _endAddressLatLng;

  @override
  void initState() {
    super.initState();
    setLatLngCoordinates();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => fitMapBounds());
  }

  void setLatLngCoordinates() {
    this.setState(() {
      _startAddressLatLng =
          LatLng(widget._step.startAddress.coordinate.latitude,
              widget._step.startAddress.coordinate.longitude);

      if (widget._step.hasEndAddress()) {
        _endAddressLatLng = LatLng(
            (widget._step as StepTransport).endAddress.coordinate.latitude,
            (widget._step as StepTransport).endAddress.coordinate.longitude);
      }
    }
    );
  }

  void fitMapBounds() {
    if (_mapController != null) {
      var bounds = _endAddressLatLng == null ? new LatLngBounds(_startAddressLatLng) : new LatLngBounds(_startAddressLatLng, _endAddressLatLng);
      _mapController.fitBounds(bounds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: _startAddressLatLng,
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            (_endAddressLatLng != null)
                ? getMultipleMarking()
                : getSimpleMarking(),
            if (_endAddressLatLng != null) getLineLayer()
          ],
        ));
  }

  LayerOptions getSimpleMarking() {
    return MarkerLayerOptions(
      markers: [
        Marker(
          width: 80.0,
          height: 80.0,
          point: _startAddressLatLng,
          builder: (ctx) =>
              Container(
                child: Icon(Icons.place, color: Colors.black),
              ),
        ),
      ],
    );
  }

  LayerOptions getMultipleMarking() {
    return MarkerLayerOptions(
      markers: [
        Marker(
          width: 80.0,
          height: 80.0,
          point: _startAddressLatLng,
          builder: (ctx) =>
              Container(
                child: Icon(Icons.place, color: Colors.black),
              ),
        ),
        Marker(
          width: 80.0,
          height: 80.0,
          point: _endAddressLatLng,
          builder: (ctx) =>
              Container(
                child: Icon(Icons.place, color: Colors.black),
              ),
        ),
      ],
    );
  }

  LayerOptions getLineLayer() {
    var points = <LatLng>[
      _startAddressLatLng,
      _endAddressLatLng
    ];
    return PolylineLayerOptions(polylines: [
      Polyline(points: points, strokeWidth: 3.0, color: Colors.black54)
    ]);
  }
}

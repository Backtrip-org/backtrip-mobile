import 'package:backtrip/model/step/step.dart';
import 'package:backtrip/model/step/step_food.dart';
import 'package:backtrip/model/step/step_leisure.dart';
import 'package:backtrip/model/step/step_lodging.dart';
import 'package:backtrip/model/step/step_transport.dart';
import 'package:backtrip/model/step/step_transport_bus.dart';
import 'package:backtrip/model/step/step_transport_plane.dart';
import 'package:backtrip/model/step/step_transport_taxi.dart';
import 'package:backtrip/model/step/step_transport_train.dart';

class StepFactory {
  final Map<String, Function> _stepEquivalencies = {
    Step.type: (json) => Step.fromJson(json),
    StepFood.type: (json) => StepFood.fromJson(json),
    StepLeisure.type: (json) => StepLeisure.fromJson(json),
    StepLodging.type: (json) => StepLodging.fromJson(json),
    StepTransport.type: (json) => StepTransport.fromJson(json),
    StepTransportBus.type: (json) => StepTransportBus.fromJson(json),
    StepTransportPlane.type: (json) => StepTransportPlane.fromJson(json),
    StepTransportTaxi.type: (json) => StepTransportTaxi.fromJson(json),
    StepTransportTrain.type: (json) => StepTransportTrain.fromJson(json),
  };

  Step getStep(dynamic json) {
    return _stepEquivalencies[json['type']](json);
  }
}

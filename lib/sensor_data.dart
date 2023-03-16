import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

///Data Class for Sensor Data
///
///This class represents a data object given from the corresponding
///[sensorID]. It also represents the datamodel for the database.
@immutable
class SensorData {
  ///Id for Objectbox generation
  final int id;

  ///Datapoints that are saved.
  late final List<double> data;

  ///Max precision of the values.
  late final int maxPrecision;

  ///Id of the sensor.
  late final SensorId sensorID;

  ///Time the data got saved.
  late final DateTime dateTime;

  ///Constructor for SensorData
  SensorData({
    required this.data,
    required this.maxPrecision,
    required this.sensorID,
    DateTime? setTime,
    this.id = 0,
  }) {
    if (setTime == null) {
      dateTime = DateTime.now();
    } else {
      dateTime = setTime;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorData &&
          (other.dateTime == dateTime &&
              other.maxPrecision == maxPrecision &&
              other.sensorID == sensorID &&
              const ListEquality().equals(other.data, data));

  @override
  int get hashCode =>
      data.hashCode +
      dateTime.hashCode +
      sensorID.hashCode +
      maxPrecision.hashCode;
}

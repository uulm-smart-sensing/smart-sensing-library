///Data Class for Sensor Data
class SensorData {
  ///Id for Objectbox generation
  int id;

  ///Datapoints that are saved.
  late List<double> data;

  ///Max precision of the values.
  late int maxPrecision;

  ///Id of the sensor.
  late int sensorID;

  ///Time the data got saved.
  late DateTime dateTime;

  ///Constructor for SensorData
  SensorData({
    required this.data,
    required this.maxPrecision,
    required this.sensorID,
    this.id = 0,
  }) {
    dateTime = DateTime.now();
  }

  ///Returns SensorData
  List<double> getData() => data;

  ///Returns MaxPrecision
  int getMaxPrecision() => maxPrecision;

  ///Returns SensorID
  int getSensorID() => sensorID;

  ///Returns DateStamp of Sensor Data
  DateTime getDateTime() => dateTime;
}

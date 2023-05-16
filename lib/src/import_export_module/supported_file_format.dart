/// The supported file formats (or filename extensions) for importing or
/// exporting files into / from the smart sensing library.
///
/// So the enum [SupportedFileFormat] contains all file formats in which the
/// sensor data can be exported (for more detailed description, how the data is
/// encoded, see the documentation of the particular file formats).
/// Likewise all of the listed file formats are supported for importing sensor
/// data into the database / local storage that is being used by the smart
/// sensing library. But the files do not only need to match the filename
/// extension but also the correct syntax (see the documentation of the
/// particular file formats for more detailed information).
enum SupportedFileFormat {
  /// Using the `json` file format means, the sensor data need to be / are
  /// encoded in the following way (example values!):
  ///
  /// ```json
  /// {
  ///   "sensorId": "<sensorId in camelCase>, e. g. 'accelerometer'",
  ///   "sensorData": [{
  ///      "data": [0, 0.1, 1.3],
  ///      "unit": "<unitcategory.unit>, e. g. 'Acceleration.gravity'",
  ///      "maxPrecision": 2,
  ///      "timestamp": 1681560654,
  ///   }]
  /// }
  /// ```
  ///
  /// The `data` array can contain as many double values as the sensor provide,
  /// so the size is not fixed to three.
  /// Furthermore, the `timestamp` is represented as the "unix
  /// epoch".
  json,

  /// Using the `csv` file format means, the sensor data need to be / are
  /// encoded in the following way:
  ///
  /// ```csv
  /// sensorId,unit,maxPrecision,timestamp,data,
  /// accelerometer,Acceleration.meterPerSecondSquared,5,1681561948,"1.4,0,9.81"
  /// accelerometer,Acceleration.gravity,5,1681562008,"0.2,0,1"
  /// ```
  ///
  /// So opening the sensor data encoded in `csv` in a spreadsheet program,
  /// would like this (example values!):
  /// |SensorId     |Unit     |maxPrecision|timestamp  |Data           |
  /// |-------------|---------|------------|-----------|---------------|
  /// |accelerometer|Accele...|2           |1681561948 |0.1, 0.15, 0.6 |
  /// |accelerometer|Accele...|2           |1681561949 |0.1, 0.15      |
  csv,

  /// Using the `xlsx` file format (so using a Excel spreadsheet) means, the
  /// sensor data need to be / are encoded in the following way in the table:
  ///
  /// |SensorId     |Unit     |maxPrecision|timestamp  |Data           |
  /// |-------------|---------|------------|-----------|---------------|
  /// |accelerometer|Accele...|2           |1681561948 |0.1, 0.15, 0.6 |
  /// |accelerometer|Accele...|2           |1681561949 |0.1, 0.15 |
  ///
  /// The array of datapoints is encoded as ', ' (whitespace!) separated list
  /// in one cell.
  ///
  /// The data will be stored in only one sheet named 'sensor_data' and so
  /// eventually contain the sensor data of multiple sensors.
  xlsx,

  /// Using the `xml` file format means, the sensor data need to be / are
  /// encoded in the following way (example values!):
  ///
  /// ```xml
  /// <root>
  /// <sensorId>sensorId (in camelCase), e. g. linearAcceleration</sensorId>
  /// <sensorData>
  ///  <data>
  ///    <dataPoint>1.4</dataPoint>
  ///    <dataPoint>0.0</dataPoint>
  ///    <dataPoint>9.81</dataPoint>
  ///  </data>
  ///  <unit>unitcategory.unit (e. g. Acceleration.gravity</unit>
  ///  <maxPrecision>5</maxPrecision>
  ///  <timestamp>1681561948</timestamp>
  /// </sensorData>
  /// </root>
  /// ```
  xml,
}

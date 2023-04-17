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
  /// 	"sensorId": "<sensorId in camelCase>, e. g. 'accelerometer'",
  /// 	"sensorData": [{
  ///      "data": [0, 0.1, 1.3],
  ///      "unit": "<unit in camelCase>, e. g. 'metersPerSecondSquared'",
  /// 		 "maxPrecision": 2,
  /// 		 "timestampInMicroseconds": 1681560654,
  /// 	}]
  /// }
  /// ```
  ///
  /// The `data` array can contain as many double values as the sensor provide,
  /// so the size is not fixed to three.
  /// Furthermore, the `timestampInMicroseconds` is represented as the "unix
  /// epoch".
  json,

  /// Using the `csv` file format means, the sensor data need to be / are
  /// encoded in the following way:
  ///
  /// ```csv
  /// SensorId;Unit;maxPrecision;timestampInMicroSeconds;Data;;
  /// accelerometer;metersPerSquareSecond;2;1681561948;0.1;0.15;0.6
  /// accelerometer;metersPerSquareSecond;2;1681561949;0.1;0.15;
  /// ```
  ///
  /// The `Data` column is the last, because depending on how many different
  /// data points the sensor produce, these additional data points can be added
  /// (sperated with _;_) at the end.
  ///
  /// So opening the sensor data encoded in `csv` in a spreadsheet program,
  /// would like this (example values!):
  /// |SensorId     |Unit     |maxPrecision|timestamp...|Data|      |      |
  /// |-------------|---------|------------|------------|----|------|------|
  /// |accelerometer|meters...|2           |1681561948  |0.1 |0.15  |0.6   |
  /// |accelerometer|meters...|2           |1681561949  |0.1 |0.15  |      |
  csv,

  /// Using the `xlsx` file format (so using a Excel spreadsheet) means, the
  /// sensor data need to be / are encoded in the following way in the table:
  ///
  /// |SensorId     |Unit     |maxPrecision|timestamp...|Data           |
  /// |-------------|---------|------------|------------|---------------|
  /// |accelerometer|meters...|2           |1681561948  |0.1, 0.15, 0.6 |
  /// |accelerometer|meters...|2           |1681561949  |0.1, 0.15 |
  ///
  /// The array of datapoints is encoded as ', ' (whitespace!) seperated list
  /// in one cell, so similar as described for the `csv` file format, but with
  /// only **one** cell for the data array and not multiple.
  xlsx,

  /// Using the `xml` file format means, the sensor data need to be / are
  /// encoded in the following way (example values!):
  ///
  /// ```xml
  /// <root>
  /// <sensorId>sensorId (in camelCase), e. g. accelerometer</sensorId>
  /// <sensorData>
  ///  <data>0</data>
  ///  <data>0.1</data>
  ///  <data>1.3</data>
  ///  <unit>unit (in camelCase, e. g. metersPerSecondSquared</unit>
  ///  <maxPrecision>2</maxPrecision>
  ///  <timestampInMicroseconds>1681560654</timestampInMicroseconds>
  /// </sensorData>
  /// </root>
  /// ```
  // xml,
}

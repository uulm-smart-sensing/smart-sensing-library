import 'sensor_data_collection.dart';

/// The result of the import.
///
/// The result is defined by the read resp. imported sensor data and a status,
/// whether the import was successful or had any errors. If an error occurred
/// while the import, the sensor data (stored in a [SensorDataCollection] object
/// ) is null.
class ImportResult {
  /// The [ImportResultStatus] of the import, indicating the import was either
  /// successful and had problems.
  final ImportResultStatus resultStatus;

  /// The imported data, if the import was possible
  final SensorDataCollection? importedData;

  /// Create a new [ImportResult] consisting of the [resultStatus] and the
  /// (optionally) [importedData].
  ///
  /// The field [importedData] should only be set, if the status is
  /// [ImportResultStatus.success]!
  ImportResult({required this.resultStatus, this.importedData});
}

/// The status of the import of sensor data, so whether the import was
/// successful or had any errors.
enum ImportResultStatus {
  /// The import was successful and all sensor data were read.
  success(""),

  /// The provided directory for the export do not exist.
  fileDoNotExist("The selected file does not exist!"),

  /// The provided list of sensorIds is empty, so no data can be exported.
  fileFormatNotSupported(
    "The file format of the selected file is not supported.",
  ),

  /// There exist no data for the given sensors and the time interval
  noSensorDataExisting(
    "There exist no sensor data in the selected file, which can be imported",
  ),

  /// The formatting of the json file is not correct.
  invalidJsonFormatting(
    "The format of the json file do not conform the JSON schema",
  ),

  /// The formatting of the xml file is not correct.
  invalidXMLFormatting(
    "The format of the xml file do not conform the XSD schema",
  );

  /// Creates a new enum value for [ImportResult].
  const ImportResultStatus(this._errorMessage);

  final String _errorMessage;

  /// Returns the corresponding error message of the result, which can be used
  /// for providing the user a hint, what went wrong while exporting the sensor
  /// data.
  ///
  /// If the export was successful and the result [success] is used,
  /// there exists no error and the [_errorMessage] is equal to an empty string.
  String showErrorMessage() => _errorMessage;
}

/// The result of the import of sensor data.
enum ImportResult {
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
  );

  /// Creates a new enum value for [ImportResult].
  const ImportResult(this._errorMessage);

  final String _errorMessage;

  /// Returns the corresponding error message of the result, which can be used
  /// for providing the user a hint, what went wrong while exporting the sensor
  /// data.
  ///
  /// If the export was successful and the result [success] is used,
  /// there exists no error and the [_errorMessage] is equal to an empty string.
  String showErrorMessage() => _errorMessage;
}

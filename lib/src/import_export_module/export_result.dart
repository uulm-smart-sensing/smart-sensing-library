/// The result of the export of sensor data.
enum ExportResult {
  /// The export was successful and all required sensor data were saved.
  success(""),

  /// The provided directory for the export do not exist.
  directoryDoNotExist("The selected directory does not exist!"),

  /// The provided list of sensorIds is empty, so no data can be exported.
  noSensorIdsProvided("At least one sensor id must be given for the export"),

  /// There exist no data for the given sensors and the time interval
  noSensorDataExisting(
    "There exist no sensor data for the provided sensors and time interval",
  );

  /// Creates a new enum value for [ExportResult].
  const ExportResult(this._errorMessage);

  final String _errorMessage;

  /// Returns the corresponding error message of the result, which can be used
  /// for providing the user a hint, what went wrong while exporting the sensor
  /// data.
  ///
  /// If the export was successful and the result [success] is used,
  /// there exists no error and the [_errorMessage] is equal to an empty string.
  String showErrorMessage() => _errorMessage;
}

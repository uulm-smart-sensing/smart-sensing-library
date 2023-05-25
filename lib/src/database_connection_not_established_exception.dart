/// Thrown when the ObjectBox database connection is not established.
class DatabaseConnectionNotEstablishedException implements Exception {
  /// Thrown when the ObjectBox database connection is not established.
  const DatabaseConnectionNotEstablishedException();

  @override
  String toString() => "Database connection is not established. "
      "Establish connection first to use the IOManager.";
}

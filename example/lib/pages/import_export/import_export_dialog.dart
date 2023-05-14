import 'package:flutter/material.dart';
import 'package:smart_sensing_library/io_manager.dart';

var exportResults = <ExportResult>[];
void showExportDialog(
  BuildContext context,
  String title,
  List<ExportResult> content,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      content: Text(
        alertmessages(content),
        style: const TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Done"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    ),
  );
}

String alertmessages(List<ExportResult> results) {
  var message = "";
  for (var result in results) {
    switch (result) {
      case ExportResult.succesful:
        message += "Data was successfully exported\n";
        break;
      case ExportResult.directoryNotExists:
        message += "Directory does not exists\n";
        break;
      case ExportResult.sensorIdEmpty:
        message += "SensorId is empty\n";
        break;
      case ExportResult.formattedDataEmpty:
        message += "Formatted Data is Empty\n";
        break;
      case ExportResult.notselectedDirectory:
        message += "Not selected a Directory\n";
        break;
    }
  }
  results.clear();
  return message;
}

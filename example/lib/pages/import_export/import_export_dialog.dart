import 'package:flutter/material.dart';
import 'package:smart_sensing_library/io_manager.dart';

class ImportExportDialog extends StatelessWidget {
  final String title;
  final ListView content;
  const ImportExportDialog(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: content,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Done"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
}

String alertmessages(ExportResult result) {
  switch (result) {
    case ExportResult.succesful:
      return "Data was sucessfully exported";
    case ExportResult.directoryNotExists:
      return "Directory does not exists";
    case ExportResult.sensorIdEmpty:
      return "SensorId is empty";
    case ExportResult.formattedDataEmpty:
      return "Formatted Data is Empty";
  }
}

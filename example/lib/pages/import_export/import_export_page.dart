import 'package:flutter/material.dart';

import '../../general_widgets/smart_sensing_appbar.dart';
import 'import_export_section_widget.dart';

class ImportExportPage extends StatelessWidget {
  const ImportExportPage({super.key});

  void _importData() {
    print("Import data not implemented yet!");
  }

  void _exportAllData() {
    print("Export all data not implemented yet!");
  }

  void _exportManualData() {
    print("Export data (with manual time interval) not implemented yet!");
  }

  @override
  Widget build(BuildContext context) {
    var importContainer = ImportExportSectionWidget(
      sectionTitle: "Import sensor data",
      buttons: SizedBox(
        width: 120,
        child: TextButton(
          onPressed: _importData,
          child: const Text("Import"),
        ),
      ),
    );

    var exportContainer = ImportExportSectionWidget(
      sectionTitle: "Export sensor data",
      buttons: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "time interval: ",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                child: TextButton(
                  onPressed: _exportAllData,
                  child: const Text("All"),
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              SizedBox(
                width: 120,
                child: TextButton(
                  onPressed: _exportManualData,
                  child: const Text("Manual"),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return SmartSensingAppBar(
      title: "Import / Export",
      body: Column(
        children: [
          importContainer,
          const SizedBox(
            height: 25,
          ),
          exportContainer,
        ],
      ),
    );
  }
}

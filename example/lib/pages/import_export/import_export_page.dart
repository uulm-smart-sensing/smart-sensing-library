import 'package:flutter/material.dart';

import '../../general_widgets/smart_sensing_appbar.dart';
import '../settings/settings_page.dart';
import 'import_export_section_widget.dart';

/// Page for importing and exporting sensor data into / from the smart
/// sensing library.
///
/// This [ImportExportPage] shows two sections:
/// * the first section is for importing sensor data,
/// so contains a [DropdownButton] and [TextButton] to
/// select for which sensor new data should be imported.
/// * the second section is for exporting sensor data,
/// so contains a [DropdownButton] and [TextButton]s to
/// select whose sensor data should be exported at which time interval
/// ("All" - meaning all collected and saved sensor data and "Manual" -
/// meaning the user can select a time interval restricting the sensor data,
/// which should be exported)
///
/// To select the files where to sensor data should be stored / load,
/// a [FilePicker] is used, so the user can easily select, which file should
/// be used.
///
/// This [ImportExportPage] is reachable through the [SettingsPage].
class ImportExportPage extends StatelessWidget {
  const ImportExportPage({super.key});

  void _importData() {}

  void _exportAllData() {}

  void _exportManualData() {}

  @override
  Widget build(BuildContext context) {
    // The widget (= section) containing all information and buttons
    // for allowing the user to import sensor data
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

    // The widget (= section) containing all information and buttons
    // for allowing the user to export sensor data
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

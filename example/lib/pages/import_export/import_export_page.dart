// import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../general_widgets/smart_sensing_appbar.dart';
import '../settings/settings_page.dart';
import 'import_export_section_widget.dart';
import 'manual_export_page.dart';

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

  /// Imports sensor data from a single file.
  ///
  /// Therefor a file picker is opened, where the user can select a file
  /// containing the sensor data, which should be imported. The selected file
  /// is delegated to the 'Import / Export' module in the smart sensing library.
  /// > Warning: Currently only one single .json file is
  /// > allowed to be imported.
  Future<void> _importData() async {
    // TODO: do not used hardcoded 'json' but instead request supported formats
    // from smart sensing library
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      allowMultiple: false,
    );

    if (result != null) {
      // var file = File(result.files.single.path!);
    }
  }

  /// Exports all sensor data of a specified sensor into a generated file, which
  /// will be located in the picked "selectedDirectory".
  ///
  /// Therefor a directory picker is opened, where the user can select the
  /// directory, where the sensor data should be exported to. If the
  /// selected directory is valid it is delegated to the 'Import / Export'
  /// module in the smart sensing library.
  Future<void> _exportAllData() async {
    var selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {}
  }

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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManualExportPage(),
                      ),
                    );
                  },
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

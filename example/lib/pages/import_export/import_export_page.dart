import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/custom_text_button.dart';
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
class ImportExportPage extends StatefulWidget {
  const ImportExportPage({super.key});

  @override
  State<ImportExportPage> createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {
  SensorId? _selectedSensorIdForImport;
  bool _importEntireDirectory = false;

  SensorId? _selectedSensorIdForExport;
  bool _exportForAllSensorIds = false;

  SupportedFileFormat? _selectedFileFormat;

  /// Setter methods for defining the state of this page by the
  /// 'Import' and 'Export' widgets.

  void _setSelectedSensorIdForImport(SensorId selectedSensorIdForImport) {
    setState(() {
      _selectedSensorIdForImport = selectedSensorIdForImport;
    });
  }

  void _setImportEntireDirectory(bool importEntireDirectory) {
    setState(() {
      _importEntireDirectory = importEntireDirectory;
    });
  }

  void _setSelectedSensorIdForExport(SensorId selectedSensorIdForExport) {
    setState(() {
      _selectedSensorIdForExport = selectedSensorIdForExport;
    });
  }

  void _setExportForAllSensorIds(bool exportForAllSensorIds) {
    setState(() {
      _exportForAllSensorIds = exportForAllSensorIds;
    });
  }

  void _setSelectedFileFormatForExport(SupportedFileFormat selectedFileFormat) {
    setState(() {
      _selectedFileFormat = selectedFileFormat;
    });
  }

  /// Imports sensor data from a single file.
  ///
  /// Therefor a file picker is opened, where the user can select a file
  /// containing the sensor data, which should be imported. The selected file
  /// is delegated to the 'Import / Export' module in the smart sensing library.
  /// > Warning: Currently only one single .json file is
  /// > allowed to be imported.
  Future<void> _importData() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: SupportedFileFormat.values.map((e) => e.name).toList(),
      allowMultiple: _importEntireDirectory,
    );

    if (result == null) return;

    if (_importEntireDirectory) {
      // List<File> files = result.paths.map((path) => File(path!)).toList();
      // TODO: call smart sensing library with 'files'
    } else if (_selectedSensorIdForImport != null) {
      // var file = File(result.files.single.path!);
      // TODO: call smart sensing library with 'file' and
      // 'selectedSensorIdForImport'
    } else {
      // TODO: provide hint, that user need to select sensorId
    }
  }

  /// Exports all sensor data of a specified sensor into a generated file, which
  /// will be located in the picked "selectedDirectory".
  ///
  /// Therefor a directory picker is opened, where the user can select the
  /// directory, where the sensor data should be exported to. If the
  /// selected directory is valid it is delegated to the 'Import / Export'
  /// module in the smart sensing library.
  Future<void> _exportData() async {
    var selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) return;

    if (_exportForAllSensorIds) {
      await IOManager().exportSensorDataToFile(
        selectedDirectory,
        _selectedFileFormat!,
        SensorId.values,
      );
    } else if (_selectedSensorIdForExport != null &&
        _selectedFileFormat != null) {
      await IOManager().exportSensorDataToFile(
        selectedDirectory,
        _selectedFileFormat!,
        [_selectedSensorIdForExport!],
      );
    } else {
      // TODO: provide hint, that user need to select sensorId
    }
  }

  /// Opens the [ManualExportPage] so the user can manually select the time
  /// interval for the export of sensor data.
  void selectTimeIntervalForExport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManualExportPage(
          selectedSensorIdForExport: _selectedSensorIdForExport!,
          exportForAllSensorIds: _exportForAllSensorIds,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The widget (= section) containing all information and buttons
    // for allowing the user to import sensor data
    var importContainer = ImportExportSectionWidget(
      sectionTitle: "Import sensor data",
      buttons: SizedBox(
        width: 120,
        child: CustomTextButton(
          onPressed:
              _selectedSensorIdForImport != null || _importEntireDirectory
                  ? _importData
                  : null,
          text: "Import",
        ),
      ),
      setSensorId: _setSelectedSensorIdForImport,
      setUseAllPossibleSensorIds: _setImportEntireDirectory,
    );

    // Export buttons enabling the user to select, at which time interval
    // ('All' possible data vs 'Manual' selected time interval) the sensor data
    // should be exported
    var exportButtons = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          child: CustomTextButton(
            onPressed: _allNeededValuesForExportSet() ? _exportData : null,
            text: "All",
            style: TextStyle(
              color: (_selectedSensorIdForExport != null &&
                      _selectedFileFormat != null)
                  ? Colors.white
                  : Colors.grey,
            ),
          ),
        ),
        const SizedBox(
          width: 25,
        ),
        SizedBox(
          width: 120,
          child: CustomTextButton(
            onPressed: _allNeededValuesForExportSet()
                ? selectTimeIntervalForExport
                : null,
            text: "Manual",
            style: TextStyle(
              color: (_selectedSensorIdForExport != null &&
                      _selectedFileFormat != null)
                  ? Colors.white
                  : Colors.grey,
            ),
          ),
        ),
      ],
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
              "time interval:",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          exportButtons,
        ],
      ),
      setSensorId: _setSelectedSensorIdForExport,
      setFileFormatForExport: _setSelectedFileFormatForExport,
      setUseAllPossibleSensorIds: _setExportForAllSensorIds,
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

  bool _allNeededValuesForExportSet() =>
      (_selectedSensorIdForExport != null && _selectedFileFormat != null) ||
      _exportForAllSensorIds;
}

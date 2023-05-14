import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:smart_sensing_library/io_manager.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/custom_datetime_picker_widget.dart';
import '../../general_widgets/custom_text_button.dart';
import '../../general_widgets/smart_sensing_appbar.dart';
import 'import_export_dialog.dart';
import 'import_export_page.dart';

/// Page for manually set the timeinterval for exporting sensor data the smart
/// sensing library.
///
/// Therefor this [ManualExportPage] shows two [CustomDatetimePickerWidget]s
/// combined with the information, whether the selector is for the start or
/// the end [DateTime].
/// These picker allows the user to specify the time interval at which the
/// sensor data will be exported.
///
/// This [ManualExportPage] is reachable through the [ImportExportPage].
class ManualExportPage extends StatefulWidget {
  /// The selected [SensorId] of the sensors, whose data should be exported.
  final SensorId selectedSensorIdForExport;

  /// A boolean indicating, whether the sensor data of all existing
  /// sensors should be exported or not.
  final bool exportForAllSensorIds;

  /// The selected [SupportedFileFormat], so the format in which the sensor
  /// data should be exported
  final SupportedFileFormat selectedFileFormat;

  const ManualExportPage({
    required this.selectedSensorIdForExport,
    required this.exportForAllSensorIds,
    required this.selectedFileFormat,
    super.key,
  });

  @override
  State<ManualExportPage> createState() => _ManualExportPageState();
}

class _ManualExportPageState extends State<ManualExportPage> {
  /// The currently set start [DateTime] for the export.
  DateTime startDatetime = DateTime.now();

  /// The currently set end [DateTime] for the export.
  DateTime endDatetime = DateTime.now();

  /// Setter methods for defining the state of this page by the
  /// datetime selector widgets.

  void _setStartDatetime(DateTime selectedStartDatetime) {
    setState(() {
      startDatetime = selectedStartDatetime;
    });
  }

  void _setEndDatetime(DateTime selectedEndDatetime) {
    setState(() {
      endDatetime = selectedEndDatetime;
    });
  }

  @override
  Widget build(BuildContext context) {
    var startDatetimeSelector = _getTimeSelector(
      "start time",
      context,
      _setStartDatetime,
    );

    var endDatetimeSelector = _getTimeSelector(
      "end time",
      context,
      _setEndDatetime,
    );

    return SmartSensingAppBar(
      title: "Export",
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select time interval for export: "),
            const SizedBox(
              height: 15,
            ),
            startDatetimeSelector,
            const SizedBox(
              height: 10,
            ),
            endDatetimeSelector,
            const SizedBox(
              height: 25,
            ),
            Center(
              child: SizedBox(
                width: 120,
                child: _isSelectedTimeIntervalValid()
                    ? CustomTextButton(
                        text: "Export",
                        onPressed: () async {
                          await _exportWithCustomTimeInterval();

                          if (!mounted) return;
                          showExportDialog(
                              context, "Export Results", exportResults);
                        },
                      )
                    : const Text(
                        "End time must be after start time and times can not"
                        "be in the future!",
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a time selector widget with additional information
  /// based on the [CustomDatetimePickerWidget].
  Widget _getTimeSelector(
    String name,
    BuildContext context,
    Function setDatetime,
  ) =>
      Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            CustomDatetimePickerWidget(setDatetime: setDatetime),
          ],
        ),
      );

  /// Exports all sensor data of a specified sensor into a generated file, which
  /// will be located in the picked "selectedDirectory".
  ///
  /// Therefor a directory picker is opened, where the user can select the
  /// directory, where the sensor data should be exported to. If the
  /// selected directory is valid it is delegated to the 'Import / Export'
  /// module in the smart sensing library combined with the set start and end
  /// datetime for the export.
  ///
  /// Afterwards the user will be navigated back to the [ImportExportPage].
  Future<void> _exportWithCustomTimeInterval() async {
    var selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      exportResults.add(ExportResult.notselectedDirectory);
      return;
    }

    if (widget.exportForAllSensorIds) {
      exportResults = await IOManager().exportSensorDataToFile(
        selectedDirectory,
        widget.selectedFileFormat,
        SensorId.values,
        startDatetime,
        endDatetime,
      );
    } else {
      exportResults = await IOManager().exportSensorDataToFile(
        selectedDirectory,
        widget.selectedFileFormat,
        [widget.selectedSensorIdForExport],
        startDatetime,
        endDatetime,
      );
    }

    // Return to "Import / Export" page
    if (!mounted) return;
    Navigator.pop(context);
  }

  bool _isSelectedTimeIntervalValid() =>
      endDatetime.isAfter(startDatetime) &&
      startDatetime.isBefore(DateTime.now()) &&
      endDatetime.isBefore(DateTime.now());
}

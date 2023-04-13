import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/custom_datetime_picker_widget.dart';
import '../../general_widgets/custom_text_button.dart';
import '../../general_widgets/smart_sensing_appbar.dart';
import 'import_export_page.dart';

class ManualExportPage extends StatefulWidget {
  /// The selected [SensorId] of the sensors, whose data should be exported.
  final SensorId selectedSensorIdForExport;

  /// A boolean indicating, whether the sensor data of all existing
  /// sensors should be exported or not.
  final bool exportForAllSensorIds;

  const ManualExportPage({
    required this.selectedSensorIdForExport,
    required this.exportForAllSensorIds,
    super.key,
  });

  @override
  State<ManualExportPage> createState() => _ManualExportPageState();
}

class _ManualExportPageState extends State<ManualExportPage> {
  DateTime startDatetime = DateTime.now();

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
                child: endDatetime.isAfter(startDatetime)
                    ? CustomTextButton(
                        text: "Export",
                        onPressed: _exportWithCustomTimeInterval,
                      )
                    : const Text(
                        "End time must be after start time!",
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Future<void> _exportWithCustomTimeInterval() async {
    var selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) return;

    if (widget.exportForAllSensorIds) {
      // TODO: call smart sensing library with 'selectedDirectory'
      // and 'SensorId.values' and the dates
    } else {
      // TODO: call smart sensing library with 'selectedDirectory'
      // and 'selectedSensorIdForExport' and the dates
    }

    // Return to "Import / Export" page

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ImportExportPage(),
      ),
    );
  }
}

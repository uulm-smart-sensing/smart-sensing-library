import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import './import_export_page.dart';

/// Widget displaying a section on the 'Import / Export' page.
///
/// This means, this widget will display a unit containing
/// * a [_sectionTitle] - showing whether this is the "Import" or
/// the "Export" section
/// * as well as [_buttons] below the [_sectionTitle] -
/// allowing the user to import or export data for the specified sensor.
///
/// For example the "Import" section could be showed by this
/// [ImportExportSectionWidget]
///
/// 'Import sensor data' (= [_sectionTitle])
///
/// supported format: json
/// Dropdown for 'Choose a sensor'
/// "Import" (= [_buttons])
///
/// This [ImportExportSectionWidget] can be used on the [ImportExportPage]
/// to display the several information.
class ImportExportSectionWidget extends StatefulWidget {
  /// The title of the section.
  ///
  /// The [_sectionTitle] should either bet set to
  /// * "Import" or
  /// * "Export".
  final String _sectionTitle;

  /// A widget containing the [_buttons] and maybe additional information
  /// of this section.
  ///
  /// For example, the "Export" section has the buttons to export 'All' or
  /// 'Manual'.
  final Widget _buttons;

  const ImportExportSectionWidget({
    super.key,
    required String sectionTitle,
    required Widget buttons,
  })  : _buttons = buttons,
        _sectionTitle = sectionTitle;

  @override
  State<StatefulWidget> createState() => _ImportExportSectionWidgetState();
}

class _ImportExportSectionWidgetState extends State<ImportExportSectionWidget> {
  String? _selectedSensor;
  final List<String> _sensorOptions = [];

  @override
  void initState() {
    super.initState();
    _sensorOptions
      ..add("All")
      ..addAll(
        SensorId.values.map(
          (e) => toBeginningOfSentenceCase(e.toString().split('.').last)!,
        ),
      )
      ..add("None");
  }

  @override
  Widget build(BuildContext context) {
    var dropdownMenuForSensorSelection = Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton(
        isExpanded: true,
        underline: const SizedBox.shrink(),
        hint: Text(
          "Choose a sensor",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        borderRadius: BorderRadius.circular(20),
        iconSize: 30,
        iconEnabledColor: Colors.white,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        dropdownColor: Theme.of(context).cardColor,
        value: _selectedSensor,
        items: _sensorOptions
            .map(
              (e) => DropdownMenuItem(
                // TODO: do not use string as value, but the corresponding
                // sensorId instead
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
        onChanged: (val) {
          setState(() {
            _selectedSensor = val;
          });
        },
      ),
    );

    // Display the text, which represents the "title" of
    // this section
    var header = Text(
      widget._sectionTitle,
      textAlign: TextAlign.left,
      style: const TextStyle(fontSize: 24),
    );

    // Display the information (content) in a rounded, dynamic sized box
    var body = Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              // TODO: do not hardcode 'json' here,
              // but aggregate supported formats from the library and
              // display the list here
              "supported format: json",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          dropdownMenuForSensorSelection,
          const SizedBox(
            height: 25,
          ),
          widget._buttons,
        ],
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(
            height: 10,
          ),
          body,
        ],
      ),
    );
  }
}

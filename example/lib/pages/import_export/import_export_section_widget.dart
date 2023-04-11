import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import './import_export_page.dart';
import '../../general_widgets/custom_dropdown_button.dart';
import '../../utils.dart';

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

  /// Function passed by the parent widget ([ImportExportPage]) to set
  /// which sensor id was selected by the user.
  final Function _setSensorId;

  /// Function passed by the parent widget ([ImportExportPage]) to set
  /// whether the user selected 'All' in the dropdown menu meaning,
  /// all possible sensor ids should be considered.
  final Function _setUseAllPossibleSensorIds;

  const ImportExportSectionWidget({
    super.key,
    required String sectionTitle,
    required Widget buttons,
    required Function setSensorId,
    required Function setUseAllPossibleSensorIds,
  })  : _buttons = buttons,
        _sectionTitle = sectionTitle,
        _setSensorId = setSensorId,
        _setUseAllPossibleSensorIds = setUseAllPossibleSensorIds;

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
          (e) => formatPascalCase(e.name),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    var dropdownMenuForSensorSelection = CustomDropdownButton(
      hint: "Choose a sensor",
      value: _selectedSensor,
      isDense: false,
      items: _sensorOptions.map(_getDropdownItemFromSensorName).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedSensor = newValue;
          // set the state of the [ImportExportPage]
          if (newValue != null) {
            if (newValue == 'All') {
              widget._setUseAllPossibleSensorIds(true);
            } else {
              widget._setUseAllPossibleSensorIds(false);
              var find = SensorId.values.firstWhere(
                (element) =>
                    element.toString() ==
                    "SensorId.${unformatPascalCase(newValue)}",
              );
              widget._setSensorId(find);
            }
          }
        });
      },
    );

    // Display the text, which represents the "title" of
    // this section
    var header = Text(
      widget._sectionTitle,
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

  /// Gets a DropdownMenuItem from the sensor name (or the entry 'All'),
  /// to create the selectable options in the dropdown button from the sensors
  /// list.
  DropdownMenuItem<String> _getDropdownItemFromSensorName(String name) =>
      DropdownMenuItem(
        value: name,
        child: Text(name),
      );
}

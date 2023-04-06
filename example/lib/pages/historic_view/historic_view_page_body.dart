import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../date_formatter.dart';
import '../../general_widgets/stylized_container.dart';
import 'historic_view_page.dart';
import 'time_selection_button.dart';
import 'visualization_selection_button.dart';

enum _Filter {
  noFilter,
  count,
  mode,
  min,
}

enum _Visualization {
  table,
  graph,
}

/// This is the widget representing the body of the [HistoricViewPage].
///
/// It contains:
/// * the time interval selection
/// * the filter selection
/// * the graph / table visualization of the filtered sensor values
class HistoricViewPageBody extends StatefulWidget {
  final SensorId sensorId;

  const HistoricViewPageBody({super.key, required this.sensorId});

  @override
  State<HistoricViewPageBody> createState() => _HistoricViewPageBodyState();
}

class _HistoricViewPageBodyState extends State<HistoricViewPageBody> {
  var selectedFilter = _Filter.noFilter;
  var selectedDuration = const Duration(minutes: 5);
  var selectedVisualization = _Visualization.table;
  late Map<int, TableColumnWidth> columnWidths;

  @override
  void initState() {
    columnWidths = _getColumnWidthsFromSensorId(widget.sensorId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var divider = const VerticalDivider(
      thickness: 1,
    );

    // Selection between different time intervals
    // When time interval is selected, new interval will be applied to table/graph
    var timeIntervalSelection = StylizedContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TimeSelectionButton(
              onPressed: () {
                setState(() {
                  selectedDuration = const Duration(minutes: 5);
                });
              },
              title: "5 min",
              isSelected:
                  selectedDuration.compareTo(const Duration(minutes: 5)) == 0,
            ),
            divider,
            TimeSelectionButton(
              onPressed: () {
                setState(() {
                  selectedDuration = const Duration(hours: 1);
                });
              },
              title: "1 h",
              isSelected:
                  selectedDuration.compareTo(const Duration(hours: 1)) == 0,
            ),
            divider,
            TimeSelectionButton(
              onPressed: () {
                setState(() {
                  selectedDuration = const Duration(hours: 12);
                });
              },
              title: "12 h",
              isSelected:
                  selectedDuration.compareTo(const Duration(hours: 12)) == 0,
            ),
            divider,
            TimeSelectionButton(
              onPressed: () {
                setState(() {
                  selectedDuration = const Duration(days: 2);
                });
              },
              title: "2 d",
              isSelected:
                  selectedDuration.compareTo(const Duration(days: 2)) == 0,
            ),
            divider,
            TimeSelectionButton(
              onPressed: () {
                setState(() {
                  selectedDuration = const Duration(days: 7);
                });
              },
              title: "1 w",
              isSelected:
                  selectedDuration.compareTo(const Duration(days: 7)) == 0,
            ),
          ],
        ),
      ),
    );

    // Selection between different filters
    // When filter is selected, new filter will be applied to table/graph
    var filterSelectionDropdown = StylizedContainer(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
      width: double.infinity,
      child: DropdownButton(
        isExpanded: true,
        isDense: true,
        iconSize: 30,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        iconEnabledColor: Colors.white,
        underline: const SizedBox.shrink(),
        value: selectedFilter,
        dropdownColor: Theme.of(context).cardColor,
        items: const [
          DropdownMenuItem(
            enabled: false,
            value: _Filter.noFilter,
            child: Text("Please select a filter"),
          ),
          DropdownMenuItem(value: _Filter.count, child: Text("Count")),
          DropdownMenuItem(value: _Filter.mode, child: Text("Mode")),
          DropdownMenuItem(value: _Filter.min, child: Text("Min")),
        ],
        onChanged: (newFilter) {
          if (newFilter == null) {
            return;
          }

          setState(() {
            selectedFilter = newFilter;
          });
        },
      ),
    );

    // Selection between different visualizations (graph and table)
    // When visualization is selected, according visualization is shown
    var visualizationSelection = IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VisualizationSelectionButton(
            onPressed: () {
              setState(() {
                selectedVisualization = _Visualization.graph;
              });
            },
            title: "Graph",
            isSelected: selectedVisualization == _Visualization.graph,
          ),
          divider,
          VisualizationSelectionButton(
            onPressed: () {
              setState(() {
                selectedVisualization = _Visualization.table;
              });
            },
            title: "Table",
            isSelected: selectedVisualization == _Visualization.table,
          ),
        ],
      ),
    );

    var paddingRow = _getPaddingRow(widget.sensorId);

    // Table that visualizes sensor data
    var visualizationTable = Table(
      columnWidths: columnWidths,
      children: [
        TableRow(
          children: [
            visualizationSelection,
            ..._getTableElementsFromSensorId(
              widget.sensorId,
              selectedVisualization,
            ),
          ],
        ),
        paddingRow,
        // TODO: Add data row using call to smart sensing library
        // and _getTableRowFromSensorData add padding with paddingRow
      ],
    );

    return Column(
      children: [
        timeIntervalSelection,
        const SizedBox(height: 10),
        filterSelectionDropdown,
        const SizedBox(height: 20),
        visualizationTable,
      ],
    );
  }
}

/// Create column widths according to the sensorId.
///
/// There are two types atm:
/// * sensors with 3 axes
/// * sensors with a single value
///
/// Both types need different column widths
Map<int, TableColumnWidth> _getColumnWidthsFromSensorId(SensorId sensorId) {
  Map<int, TableColumnWidth> columnWidths;

  switch (sensorId) {
    case SensorId.accelerometer:
    case SensorId.gyroscope:
    case SensorId.magnetometer:
    case SensorId.orientation:
    case SensorId.linearAcceleration:
      columnWidths = {
        0: const FlexColumnWidth(3),
        1: const FlexColumnWidth(),
        2: const FlexColumnWidth(),
        3: const FlexColumnWidth(),
      };
      break;
    case SensorId.barometer:
    case SensorId.thermometer:
      columnWidths = {
        0: const FlexColumnWidth(1.5),
        1: const FlexColumnWidth(),
      };
      break;
  }

  return columnWidths;
}

/// Create table header elements according to the sensorId.
///
/// There are two types atm:
/// * sensors with 3 axes
/// * sensors with a single value
///
/// Both types need different table header elements
List<Widget> _getTableElementsFromSensorId(
  SensorId sensorId,
  _Visualization selectedVisualization,
) {
  List<Text> elements;

  switch (sensorId) {
    case SensorId.accelerometer:
    case SensorId.gyroscope:
    case SensorId.magnetometer:
    case SensorId.orientation:
    case SensorId.linearAcceleration:
      // Axes are colored when graph is selected
      elements = [
        Text(
          "X",
          style: TextStyle(
            color: selectedVisualization == _Visualization.graph
                ? Colors.red
                : null,
          ),
        ),
        Text(
          "Y",
          style: TextStyle(
            color: selectedVisualization == _Visualization.graph
                ? Colors.green
                : null,
          ),
        ),
        Text(
          "Z",
          style: TextStyle(
            color: selectedVisualization == _Visualization.graph
                ? Colors.blue
                : null,
          ),
        ),
      ];
      break;
    case SensorId.barometer:
    case SensorId.thermometer:
      elements = [const Text("Value")];
      break;
  }

  return elements.map((element) => Center(child: element)).toList();
}

TableRow _getPaddingRow(SensorId sensorId) {
  int columns;
  switch (sensorId) {
    case SensorId.accelerometer:
    case SensorId.gyroscope:
    case SensorId.magnetometer:
    case SensorId.orientation:
    case SensorId.linearAcceleration:
      columns = 4;
      break;
    case SensorId.barometer:
    case SensorId.thermometer:
      columns = 2;
      break;
  }

  return TableRow(
    children: List.filled(
      columns,
      const SizedBox(height: 10),
    ),
  );
}

// ignore: unused_element
TableRow _getTableRowFromSensorData(DateTime dateTime, List<double> data) {
  var dayName = DateFormat.E(Platform.localeName).format(dateTime);
  var formattedDate = formatDate(dateTime: dateTime, shortenYear: true);
  var formattedTime = DateFormat.Hms(Platform.localeName).format(dateTime);

  return TableRow(
    children: [
      Center(
        child: Column(
          children: [
            Text("$dayName. $formattedDate"),
            Text(formattedTime),
          ],
        ),
      ),
      ...data.map((value) => Center(child: Text(value.toString()))),
    ],
  );
}

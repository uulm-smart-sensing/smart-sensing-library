import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../formatter/date_formatter.dart';
import '../../formatter/text_formatter.dart';
import '../../general_widgets/custom_dropdown_button.dart';
import '../../general_widgets/stylized_container.dart';
import '../../text_formatter.dart';
import '../../utils.dart';
import 'graph_view_page.dart';
import 'historic_view_page.dart';
import 'sensor_data.dart';
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

const int test = 0;

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
  _Filter? selectedFilter;
  var selectedDuration = const Duration(minutes: 5);
  var selectedVisualization = _Visualization.table;
  late Map<int, TableColumnWidth> columnWidths;
  late int numberOfDataPoints;

  @override
  void initState() {
    columnWidths = _getColumnWidthsFromSensorId(widget.sensorId);
    super.initState();
    if (widget.sensorId == SensorId.thermometer ||
        widget.sensorId == SensorId.barometer) {
      numberOfDataPoints = 1;
    } else {
      numberOfDataPoints = 3;
    }
  }

  int getNumberOfDataPoints() => numberOfDataPoints;
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
    var filterSelectionDropdown = CustomDropdownButton(
      hint: "Please select a filter",
      value: selectedFilter,
      isDense: true,
      items: _Filter.values
          .map(
            (value) => DropdownMenuItem(
              value: value,
              child: Text(formatPascalCase(value.name)),
            ),
          )
          .toList(),
      onChanged: (newFilter) {
        if (newFilter == null) {
          return;
        }

        setState(() {
          selectedFilter = newFilter;
        });
      },
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

    // The rows are too tightly packed, which is why a row is inserted in
    // between to serve as padding.
    var paddingRow = _getPaddingRow(widget.sensorId);

    var visualizationGraph = AspectRatio(
      aspectRatio: 1.7,
      child: Column(
        children: [
          visualizationSelection,
          const Padding(
            padding: EdgeInsets.only(
              left: 50,
              right: 0,
              top: 20,
              bottom: 4,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 6,
                right: 16,
                bottom: 4,
              ),
              child: GraphView(lineData: numberOfDataPoints),
            ),
          )
        ],
      ),
    );

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

        _getTableRowFromSensorData(
          threeAxes.take(numberOfDataPoints).toList(),
        ),
        paddingRow,
      ],
    );

    return Column(
      children: [
        timeIntervalSelection,
        const SizedBox(height: 15),
        filterSelectionDropdown,
        const SizedBox(height: 20),
        selectedVisualization == _Visualization.table
            ? visualizationTable
            : visualizationGraph,
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
            color: selectedVisualization == _Visualization.table
                ? Colors.red
                : null,
          ),
        ),
        Text(
          "Y",
          style: TextStyle(
            color: selectedVisualization == _Visualization.table
                ? Colors.green
                : null,
          ),
        ),
        Text(
          "Z",
          style: TextStyle(
            color: selectedVisualization == _Visualization.table
                ? Colors.lightBlue
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
TableRow _getTableRowFromSensorData(List<SData> data) => TableRow(
      children: [
        Center(
          child: Column(
            children: data
                .map(
                  (value) => Center(
                    child: Text(
                      '${formatDate(
                        dateTime: convertToDate(value.timestamp),
                        shortenYear: true,
                        extendWithDayName: true,
                      )}\n${DateFormat.Hms(
                        Platform.localeName,
                      ).format(convertToDate(value.timestamp))}',
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        ...data.map(
          (value) => Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 16.0,
                  width: double.infinity,
                ),
                Text(
                  value.x.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                  width: double.infinity,
                ),
                Text(
                  value.y.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                  width: double.infinity,
                ),
                Text(
                  value.z.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_sensing_library/filter_tools.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../formatter/text_formatter.dart';
import '../../formatter/time_formatter.dart';
import '../../general_widgets/custom_dropdown_button.dart';
import '../../general_widgets/stylized_container.dart';
import 'graph_view.dart';
import 'historic_view_page.dart';
import 'sensor_graph_view_data.dart';
import 'time_selection_button.dart';
import 'visualization_selection_button.dart';

enum _Filter {
  noFilter,
  maximum,
  minimum,
  average,
  median,
  standardDeviation,
  sum,
  count,
  mode,
  range,
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
  _Filter? selectedFilter;
  var selectedDuration = const Duration(seconds: 30);
  var selectedVisualization = _Visualization.table;
  late Map<int, TableColumnWidth> columnWidths;
  late int numberOfDataPoints;

  var historicSensorData = <SensorGraphViewData>[];
  var areSensorDataExisting = false;

  @override
  void initState() {
    super.initState();
    if (widget.sensorId == SensorId.thermometer ||
        widget.sensorId == SensorId.barometer) {
      numberOfDataPoints = 1;
    } else {
      numberOfDataPoints = 3;
    }
    _getDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    columnWidths = _getColumnWidthsFromSensorId(widget.sensorId);

    var divider = const VerticalDivider(thickness: 1);

    // Selection between different time intervals
    // When time interval is selected, new interval will be applied to
    // table/graph.
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
                  selectedDuration = const Duration(seconds: 30);
                });
                _getDataFromDatabase();
              },
              title: "30 s",
              isSelected:
                  selectedDuration.compareTo(const Duration(seconds: 30)) == 0,
            ),
            divider,
            TimeSelectionButton(
              onPressed: () {
                setState(() {
                  selectedDuration = const Duration(minutes: 1);
                });
                _getDataFromDatabase();
              },
              title: "1 min",
              isSelected:
                  selectedDuration.compareTo(const Duration(minutes: 1)) == 0,
            ),
            divider,
            TimeSelectionButton(
              onPressed: () {
                setState(() {
                  selectedDuration = const Duration(minutes: 5);
                });
                _getDataFromDatabase();
              },
              title: "5 min",
              isSelected:
                  selectedDuration.compareTo(const Duration(minutes: 5)) == 0,
            ),
            divider,
            TimeSelectionButton(
              onPressed: () {
                setState(() {
                  selectedDuration = const Duration(minutes: 30);
                });
                _getDataFromDatabase();
              },
              title: "30 min",
              isSelected:
                  selectedDuration.compareTo(const Duration(minutes: 30)) == 0,
            ),
            divider,
            TimeSelectionButton(
              onPressed: () {
                setState(() {
                  selectedDuration = const Duration(hours: 1);
                });
                _getDataFromDatabase();
              },
              title: "1 h",
              isSelected:
                  selectedDuration.compareTo(const Duration(hours: 1)) == 0,
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
        _getDataFromDatabase();
      },
    );

    // Selection between different visualizations (graph and table)
    // When visualization is selected, according visualization is shown
    var visualizationSelection = IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VisualizationSelectionButton(
            onPressed: historicSensorData.isNotEmpty
                ? () {
                    setState(() {
                      selectedVisualization = _Visualization.graph;
                    });
                  }
                : () => {},
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

    // Graph that visualize sensor data
    var visualizationGraph = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.height,
      child: AspectRatio(
        aspectRatio: 1.7,
        child: Center(
          child: GraphView(
            lineData: historicSensorData,
            lineDataCount:
                selectedFilter == _Filter.count ? 1 : numberOfDataPoints,
          ),
        ),
      ),
    );

    // Table that visualizes sensor data
    var tableRows = [
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
      paddingRow,
    ];
    if (selectedVisualization == _Visualization.table) {
      tableRows.addAll(
        historicSensorData
            .map(
              (sensorData) => [
                _getTableRowFromSensorData(
                  sensorData,
                  selectedFilter == _Filter.count ? 1 : numberOfDataPoints,
                ),
                paddingRow
              ],
            )
            .expand((row) => row)
            .toList(),
      );
    }
    var visualizationTable = Table(
      columnWidths: columnWidths,
      children: tableRows,
    );

    var visualizationSection = Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            areSensorDataExisting
                ? visualizationTable
                : Center(
                    child: Text(
                      "No sensor data exist yet.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
            selectedVisualization == _Visualization.graph
                ? visualizationGraph
                : const SizedBox.shrink()
          ],
        ),
      ),
    );

    return Column(
      children: [
        timeIntervalSelection,
        const SizedBox(height: 15),
        filterSelectionDropdown,
        const SizedBox(height: 20),
        visualizationSection,
      ],
    );
  }

  /// Requests the sensor data depending on the [selectedFilter] and the
  /// [selectedDuration] from the database using the library.
  Future<void> _getDataFromDatabase() async {
    FilterTools? requestedFiltertool;
    try {
      requestedFiltertool = await IOManager().getFilterFrom(widget.sensorId);
      areSensorDataExisting = true;
    } on Exception {
      areSensorDataExisting = false;
    }
    if (requestedFiltertool != null) {
      var sensorData = _getDataWithAppliedFilter(requestedFiltertool);
      var formattedSensorData = sensorData
          .map(
            (dataEntry) => SensorGraphViewData(
              timestamp: dataEntry.timestamp.microsecondsSinceEpoch / 1000.0,
              x: dataEntry.data[0],
              y: dataEntry.data.length > 1 ? dataEntry.data[1] : null,
              z: dataEntry.data.length > 2 ? dataEntry.data[2] : null,
            ),
          )
          .toList();
      if (!mounted) return;
      setState(() {
        historicSensorData = formattedSensorData;
      });
    }
  }

  List<SensorData> _getDataWithAppliedFilter(FilterTools filterTool) {
    if (selectedFilter == null) {
      return filterTool.result(interval: selectedDuration);
    }

    switch (selectedFilter!) {
      case _Filter.noFilter:
        return filterTool.result(interval: selectedDuration);
      case _Filter.maximum:
        filterTool.getMax(interval: selectedDuration);
        return filterTool.result();
      case _Filter.minimum:
        filterTool.getMin(interval: selectedDuration);
        return filterTool.result();
      case _Filter.average:
        filterTool.getAvg(interval: selectedDuration);
        return filterTool.result();
      case _Filter.median:
        filterTool.getMedian(interval: selectedDuration);
        return filterTool.result();
      case _Filter.standardDeviation:
        filterTool.getSD(interval: selectedDuration);
        return filterTool.result();
      case _Filter.sum:
        filterTool.getSum(interval: selectedDuration);
        return filterTool.result();
      case _Filter.count:
        var result = filterTool.getCount(interval: selectedDuration);
        var countValues = <SensorData>[];
        result.asMap().forEach(
              (index, value) => countValues.add(
                SensorData(
                  data: [value.roundToDouble()],
                  maxPrecision: filterTool.result().first.maxPrecision,
                  unit: filterTool.result().first.unit,

                  /// TODO: do not use DateTime.now() which only works, if the
                  /// latest data points are from now
                  timestamp: DateTime.now().subtract(
                    Duration(
                      microseconds: selectedDuration.inMicroseconds *
                          (result.length - index),
                    ),
                  ),
                ),
              ),
            );
        return countValues;
      case _Filter.mode:
        filterTool.getMode(interval: selectedDuration);
        return filterTool.result();
      case _Filter.range:
        filterTool.getRange(interval: selectedDuration);
        return filterTool.result();
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

    if (selectedFilter == _Filter.count) {
      return {
        0: const FlexColumnWidth(1.5),
        1: const FlexColumnWidth(),
      };
    }
    switch (sensorId) {
      case SensorId.accelerometer:
      case SensorId.gyroscope:
      case SensorId.magnetometer:
      case SensorId.orientation:
      case SensorId.linearAcceleration:
        columnWidths = {
          0: const FlexColumnWidth(2.5),
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

    if (selectedFilter == _Filter.count) {
      return [
        const Center(
          child: Text(
            "Count",
          ),
        ),
      ];
    }
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

    if (selectedFilter == _Filter.count) {
      columns = 2;
    } else {
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
    }

    return TableRow(
      children: List.filled(
        columns,
        const SizedBox(height: 10),
      ),
    );
  }

  TableRow _getTableRowFromSensorData(
    SensorGraphViewData sensorData,
    int numberOfDataPoints,
  ) {
    var dateTime =
        DateTime.fromMillisecondsSinceEpoch(sensorData.timestamp.toInt());
    var formattedDate = formatDate(
      dateTime: dateTime,
      shortenYear: true,
      extendWithDayName: true,
    );
    var formattedTime = DateFormat.Hms(Platform.localeName).format(dateTime);

    return TableRow(
      children: [
        Center(
          child: Column(
            children: [
              Text(formattedDate),
              Text(formattedTime),
            ],
          ),
        ),
        ...[sensorData.x, sensorData.y, sensorData.z]
            .take(numberOfDataPoints)
            .map(
              (value) => Center(child: Text(value?.toStringAsFixed(2) ?? "")),
            ),
      ],
    );
  }
}

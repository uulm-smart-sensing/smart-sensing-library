import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/stylized_container.dart';

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
            _getTimeSelectionButton(
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
            _getTimeSelectionButton(
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
            _getTimeSelectionButton(
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
            _getTimeSelectionButton(
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
            _getTimeSelectionButton(
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
            // TODO: apply filter
          });
        },
      ),
    );

    // Selection between different visualizations (graph and table)
    // When visualization is selected, according visualization is shown
    var visualizationSelection = IntrinsicHeight(
      child: Row(
        children: [
          _getVisualizationSelectionButton(
            onPressed: () {
              setState(() {
                selectedVisualization = _Visualization.graph;
              });
            },
            title: "Graph",
            isSelected: selectedVisualization == _Visualization.graph,
          ),
          divider,
          _getVisualizationSelectionButton(
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

    List<Text> xyzElements;
    if (selectedVisualization == _Visualization.graph) {
      xyzElements = [
        const Text(
          "X",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        const Text(
          "Y",
          style: TextStyle(
            color: Colors.green,
          ),
        ),
        const Text(
          "Z",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ];
    } else {
      xyzElements = [
        const Text("X"),
        const Text("Y"),
        const Text("Z"),
      ];
    }

    var visualizationTable = Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
      },
      children: [
        TableRow(
          children: [
            visualizationSelection,
            ...xyzElements,
          ],
        ),
        TableRow(
          children: [
            visualizationSelection,
            ...xyzElements,
          ],
        ),
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

Widget _getSelectionButton({
  required double width,
  required double height,
  required void Function() onPressed,
  required String title,
  required bool isSelected,
}) =>
    SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            decoration: isSelected ? TextDecoration.underline : null,
          ),
        ),
      ),
    );

Widget _getTimeSelectionButton({
  required void Function() onPressed,
  required String title,
  required bool isSelected,
}) =>
    _getSelectionButton(
      width: 50,
      height: 35,
      onPressed: onPressed,
      title: title,
      isSelected: isSelected,
    );

Widget _getVisualizationSelectionButton({
  required void Function() onPressed,
  required String title,
  required bool isSelected,
}) =>
    _getSelectionButton(
      width: 50,
      height: 20,
      onPressed: onPressed,
      title: title,
      isSelected: isSelected,
    );

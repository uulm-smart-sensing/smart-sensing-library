import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/stylized_container.dart';

enum Filter {
  noFilter,
  count,
  mode,
  min,
}

class HistoricViewPageBody extends StatefulWidget {
  final SensorId sensorId;

  const HistoricViewPageBody({super.key, required this.sensorId});

  @override
  State<HistoricViewPageBody> createState() => _HistoricViewPageBodyState();
}

class _HistoricViewPageBodyState extends State<HistoricViewPageBody> {
  var selectedFilter = Filter.noFilter;
  var selectedDuration = const Duration(minutes: 5);

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
            ),
            divider,
            _getTimeSelectionButton(
              onPressed: () {
                setState(() {
                  selectedDuration = const Duration(hours: 1);
                });
              },
              title: "1 h",
            ),
            divider,
            _getTimeSelectionButton(
              onPressed: () {
                setState(() {
                  selectedDuration = const Duration(hours: 12);
                });
              },
              title: "12 h",
            ),
            divider,
            _getTimeSelectionButton(
              onPressed: () {
                setState(() {
                  selectedDuration = const Duration(days: 2);
                });
              },
              title: "2 d",
            ),
            divider,
            _getTimeSelectionButton(
              onPressed: () {
                setState(() {
                  selectedDuration = const Duration(days: 7);
                });
              },
              title: "1 w",
            ),
          ],
        ),
      ),
    );

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
            value: Filter.noFilter,
            child: Text("Please select a filter"),
          ),
          DropdownMenuItem(value: Filter.count, child: Text("Count")),
          DropdownMenuItem(value: Filter.mode, child: Text("Mode")),
          DropdownMenuItem(value: Filter.min, child: Text("Min")),
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

    return Column(
      children: [
        timeIntervalSelection,
        const SizedBox(height: 10),
        filterSelectionDropdown,
      ],
    );
  }
}

Widget _getTimeSelectionButton({
  required void Function() onPressed,
  required String title,
}) =>
    SizedBox(
      width: 50,
      height: 35,
      child: TextButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );

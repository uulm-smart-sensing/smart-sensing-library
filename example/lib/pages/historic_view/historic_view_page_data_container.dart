import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/stylized_container.dart';

enum Filter {
  count,
  mode,
  min,
  noFilter,
}

class HistoricViewPageDataContainer extends StatefulWidget {
  final SensorId sensorId;

  const HistoricViewPageDataContainer({super.key, required this.sensorId});

  @override
  State<HistoricViewPageDataContainer> createState() =>
      _HistoricViewPageDataContainerState();
}

class _HistoricViewPageDataContainerState
    extends State<HistoricViewPageDataContainer> {
  @override
  Widget build(BuildContext context) {
    var filterSelectionDropdown = StylizedContainer(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      width: double.infinity,
      child: DropdownButton(
        isExpanded: true,
        iconSize: 30,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        iconEnabledColor: Colors.white,
        underline: const SizedBox.shrink(),
        value: Filter.noFilter,
        items: const [
          DropdownMenuItem(value: Filter.count, child: Text("Count")),
          DropdownMenuItem(value: Filter.mode, child: Text("Mode")),
          DropdownMenuItem(value: Filter.min, child: Text("Min")),
          DropdownMenuItem(
            value: Filter.noFilter,
            child: Text("Please select a filter"),
          ),
        ],
        onChanged: (obj) {
          print(obj);
        },
      ),
    );

    return Column(
      children: [
        filterSelectionDropdown,
      ],
    );
  }
}

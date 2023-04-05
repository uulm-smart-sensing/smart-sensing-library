import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/stylized_container.dart';
import 'historic_view_page_data_container.dart';

class HistoricViewPageBody extends StatelessWidget {
  final SensorId sensorId;

  const HistoricViewPageBody({super.key, required this.sensorId});

  @override
  Widget build(BuildContext context) {
    var divider = const VerticalDivider(
      thickness: 1,
    );

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
                // TODO: apply 5 min filter
              },
              title: "5 min",
            ),
            divider,
            _getTimeSelectionButton(
              onPressed: () {
                // TODO: apply 1 h filter
              },
              title: "1 h",
            ),
            divider,
            _getTimeSelectionButton(
              onPressed: () {
                // TODO: apply 12 h filter
              },
              title: "12 h",
            ),
            divider,
            _getTimeSelectionButton(
              onPressed: () {
                // TODO: apply 2 d filter
              },
              title: "2 d",
            ),
            divider,
            _getTimeSelectionButton(
              onPressed: () {
                // TODO: apply 1 w filter
              },
              title: "1 w",
            ),
          ],
        ),
      ),
    );

    return Column(
      children: [
        timeIntervalSelection,
        const SizedBox(height: 10),
        HistoricViewPageDataContainer(sensorId: sensorId),
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

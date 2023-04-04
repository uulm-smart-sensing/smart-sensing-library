import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

class HistoricViewPageBody extends StatelessWidget {
  final SensorId sensorId;

  const HistoricViewPageBody({super.key, required this.sensorId});

  @override
  Widget build(BuildContext context) {
    var divider = const VerticalDivider(
      thickness: 1,
      color: Colors.white,
    );

    var timeIntervalSelection = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        color: Color.fromARGB(255, 38, 0, 80),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _getTimeSelectionButton(
              onPressed: () {},
              title: "5 min",
            ),
            divider,
            _getTimeSelectionButton(
              onPressed: () {},
              title: "1 h",
            ),
            divider,
            _getTimeSelectionButton(
              onPressed: () {},
              title: "12 h",
            ),
            divider,
            _getTimeSelectionButton(
              onPressed: () {},
              title: "2 d",
            ),
            divider,
            _getTimeSelectionButton(
              onPressed: () {},
              title: "1 w",
            ),
          ],
        ),
      ),
    );

    return Column(
      children: [
        timeIntervalSelection,
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

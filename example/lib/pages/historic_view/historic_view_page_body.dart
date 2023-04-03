import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

class HistoricViewPageBody extends StatelessWidget {
  final SensorId sensorId;

  const HistoricViewPageBody({super.key, required this.sensorId});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 12,
        ),
        decoration: const ShapeDecoration(
          shape: StadiumBorder(),
          color: Color.fromARGB(255, 38, 0, 80),
        ),
        child: const Text(
          "5 min | 1 h | 12 h | 2 d | 1 w",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      );
}

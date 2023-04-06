import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import 'historic_view_page_container.dart';

class HistoricViewPage extends StatelessWidget {
  final SensorId sensorId;

  const HistoricViewPage({
    super.key,
    required this.sensorId,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Historic view"),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: HistoricViewPageContainer(sensorId: sensorId),
        ),
      );
}

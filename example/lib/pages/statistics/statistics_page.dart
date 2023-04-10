import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../date_formatter.dart';
import '../../general_widgets/smart_sensing_appbar.dart';
import '../../general_widgets/stylized_container.dart';
import '../../utils.dart';
import '../historic_view/historic_view_page.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var sensorList = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("All"),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView(
              children: SensorId.values
                  .map((id) => _getSensorListItem(id, context))
                  .toList(),
            ),
          ),
        ],
      ),
    );

    return SmartSensingAppBar(
      title: "Statistics",
      subtitle: formatDate(
        dateTime: DateTime.now(),
        locale: "de",
        extendWithDayName: true,
      ),
      body: sensorList,
    );
  }

  Widget _getSensorListItem(SensorId sensorId, BuildContext context) {
    var sensorButton = StylizedContainer(
      height: 50,
      width: 330,
      padding: const EdgeInsets.all(15),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoricViewPage(
                sensorId: sensorId,
              ),
            ),
          );
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            formatPascalCase(sensorId.toString().split(".").last),
          ),
        ),
      ),
    );

    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        sensorButton,
      ],
    );
  }
}

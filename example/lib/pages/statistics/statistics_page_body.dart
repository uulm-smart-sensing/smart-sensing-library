import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../formatter/text_formatter.dart';
import '../../general_widgets/stylized_container.dart';
import '../historic_view/historic_view_page.dart';

class StatisticsPageBody extends StatelessWidget {
  final double spaceBetweenChildren;
  final List<Widget> children;
  final String noChildrenText;

  const StatisticsPageBody({
    super.key,
    this.spaceBetweenChildren = 5,
    this.children = const [],
    this.noChildrenText = "No elements",
  });

  @override
  Widget build(BuildContext context) {
    var bodyElements = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      bodyElements.add(children[i]);
      if (i < children.length - 1) {
        bodyElements.add(
          SizedBox(height: spaceBetweenChildren),
        );
      }
    }

    if (bodyElements.isEmpty) {
      bodyElements.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            noChildrenText,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Column(children: bodyElements);
  }
}

// Create the button (= List item) for a sensor with [sensorId]
Widget getSensorListItem(SensorId sensorId, BuildContext context) {
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
          formatPascalCase(sensorId.name),
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

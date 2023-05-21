import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../formatter/text_formatter.dart';
import '../../general_widgets/app_bar_with_header.dart';
import 'historic_view_page_body.dart';
import 'sensor_info_tooltip.dart';

class HistoricViewPage extends StatefulWidget {
  final SensorId sensorId;

  const HistoricViewPage({
    super.key,
    required this.sensorId,
  });

  @override
  State<HistoricViewPage> createState() => _HistoricViewPageState();
}

class _HistoricViewPageState extends State<HistoricViewPage> {
  var isTooltipVisible = false;

  @override
  Widget build(BuildContext context) {
    var tooltip = _getTooltip(widget.sensorId);

    var children = <Widget>[
      HistoricViewPageBody(sensorId: widget.sensorId),
    ];

    if (isTooltipVisible) {
      children.add(tooltip);
    }

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formatPascalCase(widget.sensorId.name),
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        // i Icon that displays the tooltip when tapped on
        GestureDetector(
          child: const SizedBox.square(
            dimension: 30,
            child: Icon(Icons.info),
          ),
          onTapDown: (details) {
            setState(() {
              isTooltipVisible = true;
            });
          },
          onTapUp: (details) {
            setState(() {
              isTooltipVisible = false;
            });
          },
        ),
      ],
    );

    var exampleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          "Example",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        const Divider(thickness: 2),
        const Text.rich(
          TextSpan(
            text: "Show me the (y-) minimum of all hourly averages from "
                "yesterday: ",
            style: TextStyle(
              fontSize: 16,
            ),
            children: <InlineSpan>[
              TextSpan(
                text: "(= avg(1 hour).min(axis = y))",
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
        const SizedBox(height: 5),
        _getTextForExample1(),
        const SizedBox(height: 10),
        const Text.rich(
          TextSpan(
            text: "Show me the range of 1 min maxima (in x-axis) of datapoints "
                "from last hour: ",
            style: TextStyle(
              fontSize: 16,
            ),
            children: <InlineSpan>[
              TextSpan(
                text: "(= max(1 min).range())",
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
        _getTextForExample2(),
        const SizedBox(height: 20),
      ],
    );

    return Scaffold(
      appBar: AppBarWithHeader(titleText: "Historic View", header: header),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // The overlay contains the body and controls the tooltip which is
            // displayed on top of the body
            Flexible(child: Stack(children: children)),
            exampleSection,
          ],
        ),
      ),
    );
  }

  /// Fetching data from the database and filter them corresponding to the
  /// description of example one in the "Example" section.
  ///
  /// The result value will be displayed within [Text] widget.
  Widget _getTextForExample1() => FutureBuilder(
        future: Future.sync(() async {
          var filterTool = await IOManager().getFilterFrom(
            widget.sensorId,
            from: DateTime.now().subtract(const Duration(days: 1)),
          );

          var filteredData = filterTool!
            ..getAvg(interval: const Duration(hours: 1))
            ..getMin(axis: 1);

          return filteredData.result().first;
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var sensorData = snapshot.data!.data;
            var resultText = sensorData.length > 1
                ? sensorData[1]
                : "y-value does not exist";
            return Text(
              "    Result: $resultText",
              style: const TextStyle(fontSize: 16),
            );
          }
          return const Text(
            "    Could not get data!",
            style: TextStyle(fontSize: 14),
          );
        },
      );

  /// Fetching data from the database and filter them corresponding to the
  /// description of example two in the "Example" section.
  ///
  /// The result value will be displayed within [Text] widget.
  Widget _getTextForExample2() => FutureBuilder(
        future: Future.sync(() async {
          var filterTool = await IOManager().getFilterFrom(
            widget.sensorId,
            from: DateTime.now().subtract(const Duration(hours: 1)),
          );

          var filteredData = filterTool!
            ..getMax(interval: const Duration(minutes: 1), axis: 0)
            ..getRange();

          return filteredData.result().first;
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var sensorData = snapshot.data!.data;
            return Text(
              "    Result: ${sensorData[0]}",
              style: const TextStyle(fontSize: 16),
            );
          }
          return const Text(
            "    Could not get data!",
            style: TextStyle(fontSize: 14),
          );
        },
      );

  /// Request the sensor information about the sensor with the [sensorId] and
  /// if the sensor is running and the information are known, a
  /// [SensorInfoTooltip] containing this data is returned.
  Widget _getTooltip(SensorId sensorId) => FutureBuilder(
        future: Future.sync(() async {
          // Check, whether sensor is used.
          var isSensorRunning = await IOManager()
              .getUsedSensors()
              .then((list) => list.contains(sensorId));
          if (isSensorRunning) {
            return IOManager().getSensorInfo(sensorId);
          }
          return null;
        }),
        builder: (context, snapshot) {
          // Check, if sensor info could be requested or if the sensor
          // with the given id is not running.
          if (!snapshot.hasData) {
            // return const SizedBox.shrink();
            /// TODO (for the reviewer): check, which method is best
            return SensorInfoTooltip(sensorId: sensorId);
          }

          var sensorInfo = snapshot.data!;
          return SensorInfoTooltip(sensorId: sensorId, sensorInfo: sensorInfo);
        },
      );
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../utils.dart';
import 'historic_view_page_body.dart';
import 'sensor_info_tooltip.dart';

/// This [Widget] wraps the header and body to control the state of the tooltip.
class HistoricViewPageContainer extends StatefulWidget {
  final SensorId sensorId;

  const HistoricViewPageContainer({super.key, required this.sensorId});

  @override
  State<HistoricViewPageContainer> createState() =>
      _HistoricViewPageContainerState();
}

class _HistoricViewPageContainerState extends State<HistoricViewPageContainer> {
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              formatPascalCase(widget.sensorId.name),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const Text(
              // TODO: Replace with call to smart sensing library
              "(in m/s^2, prec: 2)",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
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
      children: const [
        Text(
          "Example",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        Divider(thickness: 2),
        Text.rich(
          TextSpan(
            text: "Show me the (y-) minimum of all hourly averages from "
                "yesterday ",
            children: <InlineSpan>[
              TextSpan(
                text: "(= avg(1 hour, axis = y).min())",
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
        // TODO: Make call to smart sensing library
        SizedBox(height: 10),
        Text.rich(
          TextSpan(
            text: "Show me the range of amount of datapoints a day from last "
                "week",
            children: <InlineSpan>[
              TextSpan(
                text: "(= count(1 day).range())",
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
        // TODO: Make call to smart sensing library
        SizedBox(height: 5),
      ],
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            header,
            const Divider(thickness: 2),
            // The overlay contains the body and controls the tooltip which is
            // displayed on top of the body
            Stack(children: children),
          ],
        ),
        exampleSection,
      ],
    );
  }
}

Widget _getTooltip(SensorId sensorId) => FutureBuilder(
      future: Future.sync(() async {
        // TODO: Replace with call to smart sensing library
        var sensorInfo = SensorInfo(
          unit: Unit.celsius,
          accuracy: SensorAccuracy.high,
          timeIntervalInMilliseconds: 100,
        );
        return jsonEncode(sensorInfo.encode());
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        var sensorInfo = SensorInfo.decode(jsonDecode(snapshot.data!));
        return SensorInfoTooltip(sensorId: sensorId, sensorInfo: sensorInfo);
      },
    );

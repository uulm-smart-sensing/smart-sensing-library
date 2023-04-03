import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import 'historic_view_page_body.dart';
import 'sensor_info_tooltip.dart';

/// This [Widget] wraps the header and body to control the state of the tooltip.
class HistoricViewPageBodyContainer extends StatefulWidget {
  final SensorId sensorId;

  const HistoricViewPageBodyContainer({super.key, required this.sensorId});

  @override
  State<HistoricViewPageBodyContainer> createState() =>
      _HistoricViewPageBodyContainerState();
}

class _HistoricViewPageBodyContainerState
    extends State<HistoricViewPageBodyContainer> {
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
              _capitalizeSensorName(widget.sensorId.name),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const Text(
              "(in m/s^2, prec: 2)",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
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

    return Column(
      children: [
        header,
        const Divider(thickness: 2),
        // The overlay contains the body and controls the tooltip which is
        // displayed on top of the body
        Stack(children: children),
      ],
    );
  }
}

String _capitalizeSensorName(String name) => name
    .split(RegExp("(?=[A-Z])"))
    .map(
      (word) =>
          word.characters.take(1).toUpperCase().join() +
          word.characters.skip(1).join(),
    )
    .join(" ");

Widget _getTooltip(SensorId sensorId) => FutureBuilder(
      future: Future.sync(() async {
        // ignore: todo
        // TODO: replace with call to smart sensing library
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

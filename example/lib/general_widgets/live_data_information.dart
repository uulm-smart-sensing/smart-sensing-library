import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../text_formatter.dart';
import '../theme.dart';

/// This widget shows live sensor data for the given [SensorId].
///
/// Shows the name, main data and the time since the last update.
/// A short version is available if [shortFormat] is set to true.
/// By default the long version is returned.
/// Widget should be wrapped e.g. by a [Container].
/// An example implementation would be:
/// ```dart
/// BrickContainer(
///   color: sensorIdToColor[SensorId.accelerometer],
///   child: const LiveDataInformation(
///     id: SensorId.accelerometer,
///     headLineFontSize: 15,
///   ),
/// );
/// ```
class LiveDataInformation extends StatefulWidget {
  final SensorId id;
  final EdgeInsets padding;
  final double mainDataFontSize;
  final double headLineFontSize;
  final double timeFontSize;
  final bool shortFormat;

  const LiveDataInformation({
    super.key,
    required this.id,
    this.padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    this.mainDataFontSize = 14,
    this.headLineFontSize = 15,
    this.timeFontSize = 13,
    this.shortFormat = false,
  });

  @override
  State<LiveDataInformation> createState() => _LiveDataInformationState();
}

class _LiveDataInformationState extends State<LiveDataInformation> {
  Duration lastUpdate = Duration.zero;
  DateTime lastTimeStamp = DateTime.now().toUtc();
  final double? mainDataSize = null;
  List<double?> mainData = [];
  Unit? unit;
  int? maxPrecision;
  StreamSubscription? _subscription;

  /// Gets the corresponding data stream of [SensorId]
  /// and updates the internal data.
  @override
  void initState() {
    super.initState();
    _subscription = IOManager().getSensorStream(widget.id)?.listen(
      (event) {
        setState(() {
          var tmpDateTime = DateTime.fromMicrosecondsSinceEpoch(
            event.timestampInMicroseconds,
          );
          lastUpdate = tmpDateTime.difference(lastTimeStamp);
          lastTimeStamp = tmpDateTime;
          mainData = event.data;
          unit ??= event.unit;
          maxPrecision ??= event.maxPrecision;
        });
      },
    );
  }

  ///Stops listening when widget gets disposed.
  @override
  Future<void> dispose() async {
    super.dispose();
    await _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: widget.padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      formatPascalCase(widget.id.name),
                      style: TextStyle(
                        fontSize: widget.headLineFontSize,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _mainDataText(
                      mainData,
                      unit,
                      maxPrecision ?? 3,
                      widget.mainDataFontSize,
                    ),
                  ),
                  !widget.shortFormat
                      ? _updateText(lastUpdate, widget.timeFontSize)
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                sensorIdToIcon[widget.id],
                size: widget.headLineFontSize,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
}

/// Converts the main data to a readable string for the widget.
String _fromData(List<double?> data, Unit unit, int maxPrecision) {
  var values = data.whereType<double>().toList();

  if (values.isEmpty) {
    return "No Data";
  }

  return values
      .map(
        (value) => "${value.toStringAsFixed(min(maxPrecision, 3))} "
            "${_unitConverter(unit)}",
      )
      .join("\n");
}

/// Converts the [Unit] enum to the corresponing unit string.
String _unitConverter(Unit unit) {
  switch (unit) {
    case Unit.metersPerSecondSquared:
      return "m/s²";
    case Unit.gravitationalForce:
      return "N";
    case Unit.radiansPerSecond:
      return "rad/s";
    case Unit.degreesPerSecond:
      return "deg/s";
    case Unit.microTeslas:
      return "µT";
    case Unit.radians:
      return "rad";
    case Unit.degrees:
      return "deg";
    case Unit.hectoPascal:
      return "hPa";
    case Unit.kiloPascal:
      return "kPa";
    case Unit.bar:
      return "bar";
    case Unit.celsius:
      return "°C";
    case Unit.fahrenheit:
      return "°F";
    case Unit.kelvin:
      return "K";
    case Unit.unitless:
    default:
      return "";
  }
}

/// Creates the [Text] widget for the main data block.
/// Is responsive if there is only one data Point or many.
Widget _mainDataText(
  List<double?> data,
  Unit? unit,
  int maxPrecision,
  double size,
) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          _fromData(data, unit ?? Unit.unitless, maxPrecision),
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: size,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

/// Creates the [Text] widget for the update block.
Widget _updateText(Duration lastUpdate, double size) => Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: "Last update: \n   ${_formatDuration(lastUpdate)}",
          style: TextStyle(
            fontSize: size,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

/// Creates a [String] corresponding to the best time unit.
String _formatDuration(Duration lastUpdate) {
  if (lastUpdate.inMilliseconds < 1000) {
    return "${lastUpdate.inMilliseconds} ms ago";
  }
  if (lastUpdate.inSeconds < 60) {
    return "${lastUpdate.inSeconds} sec ago";
  }
  if (lastUpdate.inMinutes < 60) {
    return "${lastUpdate.inMinutes} min ago";
  }
  return "${lastUpdate.inHours} h ago";
}

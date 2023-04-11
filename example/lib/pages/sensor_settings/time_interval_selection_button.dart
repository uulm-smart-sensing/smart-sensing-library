import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';
import 'time_interval_picker.dart';

class TimeIntervalSelectionButton extends StatefulWidget {
  final SensorId sensorId;
  final void Function(int newValue) onChanged;

  const TimeIntervalSelectionButton({
    super.key,
    required this.sensorId,
    required this.onChanged,
  });

  @override
  State<TimeIntervalSelectionButton> createState() =>
      _TimeIntervalSelectionButtonState();
}

class _TimeIntervalSelectionButtonState
    extends State<TimeIntervalSelectionButton> {
  late int timeIntervalInMilliseconds;

  @override
  Future<void> initState() async {
    timeIntervalInMilliseconds = await _getTimeIntervalInMs(widget.sensorId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialButton(
        color: const Color.fromARGB(255, 23, 27, 137),
        shape: const StadiumBorder(),
        onPressed: () async {
          var currentDateTime = DateTime.fromMillisecondsSinceEpoch(
            timeIntervalInMilliseconds,
            isUtc: true,
          );

          var newDate = await DatePicker.showPicker(
            context,
            pickerModel: TimeIntervalPicker(
              startTime: currentDateTime,
            ),
          );

          if (newDate == null) {
            return;
          }

          setState(() {
            timeIntervalInMilliseconds = newDate.millisecondsSinceEpoch;
          });
          widget.onChanged.call(timeIntervalInMilliseconds);
        },
        child: const Text(
          "Update interval",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
}

Future<int> _getTimeIntervalInMs(SensorId sensorId) async {
  await Future.delayed(const Duration(milliseconds: 300));
  var timeInterval = 100;
  return timeInterval;
}

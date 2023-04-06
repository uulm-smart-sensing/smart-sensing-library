import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';
import 'time_interval_picker.dart';

class TimeIntervalSelectionButton extends StatefulWidget {
  final SensorId sensorId;
  final void Function(int newValue) onChanged;
  final void Function(int initialValue) init;

  const TimeIntervalSelectionButton({
    super.key,
    required this.sensorId,
    required this.onChanged,
    required this.init,
  });

  @override
  State<TimeIntervalSelectionButton> createState() =>
      _TimeIntervalSelectionButtonState();
}

class _TimeIntervalSelectionButtonState
    extends State<TimeIntervalSelectionButton> {
  int? timeIntervalInMilliseconds;

  @override
  Widget build(BuildContext context) {
    var button = _getTimeIntervalSelectionButtonBase(() async {
      var currentDateTime = DateTime.fromMillisecondsSinceEpoch(
        timeIntervalInMilliseconds!,
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
      widget.onChanged.call(timeIntervalInMilliseconds!);
    });

    if (timeIntervalInMilliseconds == null) {
      // Use FutureBuilder to get configured time interval
      return FutureBuilder(
        future: _getTimeIntervalInMs(widget.sensorId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            timeIntervalInMilliseconds = snapshot.data;
            widget.init.call(timeIntervalInMilliseconds!);
            return button;
          }

          return _getTimeIntervalSelectionButtonBase(() {});
        },
      );
    } else {
      return button;
    }
  }
}

Future<int> _getTimeIntervalInMs(SensorId sensorId) async {
  await Future.delayed(const Duration(milliseconds: 300));
  var timeInterval = 100;
  return timeInterval;
}

Widget _getTimeIntervalSelectionButtonBase(void Function() onPressed) =>
    MaterialButton(
      color: const Color.fromARGB(255, 23, 27, 137),
      shape: const StadiumBorder(),
      onPressed: onPressed,
      child: const Text(
        "Update interval",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
      ),
    );

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';
import '../../general_widgets/custom_text_button.dart';
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
  int? timeIntervalInMilliseconds;

  @override
  Widget build(BuildContext context) {
    var button = CustomTextButton(
      text: "Update interval",
      onPressed: () async {
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
      },
    );

    if (timeIntervalInMilliseconds == null) {
      // Use FutureBuilder to get configured time interval
      return FutureBuilder(
        future: _getTimeIntervalInMs(widget.sensorId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            timeIntervalInMilliseconds = snapshot.data;
            widget.onChanged.call(timeIntervalInMilliseconds!);
            return button;
          }

          return CustomTextButton(text: "Update interval", onPressed: () {});
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

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../../general_widgets/custom_text_button.dart';
import '../../general_widgets/custom_text_button_template.dart';
import 'time_interval_picker.dart';

/// [CustomTextButton] that opens a [TimeIntervalPicker] to select a time
/// interval for a sensor.
class TimeIntervalSelectionButton extends StatefulWidget {
  final int timeIntervalInMilliseconds;
  final void Function(int newValue) onChanged;
  final int minTimeIntervalInMilliseconds;

  const TimeIntervalSelectionButton({
    super.key,
    required this.timeIntervalInMilliseconds,
    required this.onChanged,
    this.minTimeIntervalInMilliseconds = 0,
  });

  @override
  State<TimeIntervalSelectionButton> createState() =>
      _TimeIntervalSelectionButtonState();
}

class _TimeIntervalSelectionButtonState
    extends State<TimeIntervalSelectionButton> {
  late int timeIntervalInMilliseconds;

  @override
  void initState() {
    timeIntervalInMilliseconds = widget.timeIntervalInMilliseconds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var duration =
        DateTime.fromMillisecondsSinceEpoch(timeIntervalInMilliseconds);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      width: double.infinity,
      child: CustomTextButtonTemplate(
        textButtonChild: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("${duration.minute}"),
            const Text(":"),
            Text("${duration.second}"),
            const Text(":"),
            Text("${duration.millisecond}"),
          ],
        ),
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

          if (newDate == null || !mounted) {
            return;
          }
          // Shows alert dialog when time is to low and doesn't change value.
          if (newDate.microsecondsSinceEpoch <
              widget.minTimeIntervalInMilliseconds) {
            var minimumDuration = formatDuration(
              Duration(milliseconds: widget.minTimeIntervalInMilliseconds),
            );
            await showDialog(
              context: context,
              builder: (_) => _createDialog(
                text: Text("Interval can't be lower than $minimumDuration."),
              ),
            );
            return;
          }
          setState(() {
            timeIntervalInMilliseconds = newDate.millisecondsSinceEpoch;
          });
          widget.onChanged.call(timeIntervalInMilliseconds);
        },
      ),
    );
  }
}

Widget _createDialog({required Text text}) {
  if (Platform.isAndroid) {
    return AlertDialog(
      title: text,
    );
  }
  return CupertinoAlertDialog(
    title: text,
  );
}

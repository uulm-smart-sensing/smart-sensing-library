import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../date_formatter.dart';

import 'stylized_container.dart';

class CustomDatetimePickerWidget extends StatefulWidget {
  /// A [Function] for setting the selected datetime from the [DatePicker].
  final Function setDatetime;

  const CustomDatetimePickerWidget({super.key, required this.setDatetime});

  @override
  State<CustomDatetimePickerWidget> createState() =>
      _CustomDatetimePickerWidgetState();
}

class _CustomDatetimePickerWidgetState
    extends State<CustomDatetimePickerWidget> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: () async {
          selectedDateTime = (await DatePicker.showDateTimePicker(
            context,

            /// TODO: figure out a way to get the locale of the device
            locale: LocaleType.de,
            onChanged: (time) => {
              setState(
                () {
                  selectedDateTime = time;
                  widget.setDatetime(time);
                },
              )
            },
          ))!;
        },
        child: SizedBox(
          width: 275,
          child: StylizedContainer(
            padding: const EdgeInsets.all(10),
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Text(
              _getSelectedDatetimeAsFormattedText(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      );

  String _getSelectedDatetimeAsFormattedText() =>
      "${formatDate(dateTime: selectedDateTime, extendWithDayName: true)}  "
      " ${selectedDateTime.hour.toString().padLeft(2, "0")} : "
      " ${selectedDateTime.minute.toString().padLeft(2, "0")}";
}

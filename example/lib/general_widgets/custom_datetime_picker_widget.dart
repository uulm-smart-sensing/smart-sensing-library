import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../formatter/locale_converter.dart';
import '../formatter/time_formatter.dart';
import 'stylized_container.dart';

/// A custom date and time picker based on [DatePicker].
///
/// This widget displays a datetime in the format:
/// "<dayname>   <hour> : <minute>"
/// in a [StylizedContainer] and opens a `DateTimePicker` (contained in
/// the [DatePicker] package) where the user can set the desired date and time.
/// Than the selected [DateTime] will be shown in the [StylizedContainer] in the
/// format like described above.
///
/// It can be used on every page in the smart sensing library demo app, where
/// a datetime selector is needed.
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
  /// The selected [DateTime] from the [DatePicker].
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
            locale: getLocaleTypeFromSystemLocale(),
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

  /// Creates a formatted string which contains the selected datetime.
  ///
  /// The format is: "<dayname>   <hour> : <minute>".
  String _getSelectedDatetimeAsFormattedText() =>
      "${formatDate(dateTime: selectedDateTime, extendWithDayName: true)}  "
      " ${selectedDateTime.hour.toString().padLeft(2, "0")} : "
      " ${selectedDateTime.minute.toString().padLeft(2, "0")}";
}

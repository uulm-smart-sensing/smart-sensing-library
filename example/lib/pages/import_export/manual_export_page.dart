import 'package:flutter/material.dart';

import '../../general_widgets/smart_sensing_appbar.dart';

class ManualExportPage extends StatelessWidget {
  final Function _setStartDatetime;

  final Function _setEndDatetime;

  const ManualExportPage({
    super.key,
    required Function setStartDatetime,
    required Function setEndDatetime,
  })  : _setStartDatetime = setStartDatetime,
        _setEndDatetime = setEndDatetime;

  @override
  Widget build(BuildContext context) => SmartSensingAppBar(
        title: "Export",
        // TODO: change by setting correct body
        body: TextButton(
          onPressed: () {
            _setStartDatetime(DateTime.now());
            _setEndDatetime(DateTime.now());
          },
          child: const Text("All"),
        ),
      );
}

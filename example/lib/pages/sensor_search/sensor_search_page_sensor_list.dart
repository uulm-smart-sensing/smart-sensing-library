import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import 'sensor_toggle_list_element.dart';

class SensorSearchPageSensorList extends StatefulWidget {
  final SensorId sensorId;

  const SensorSearchPageSensorList({super.key, required this.sensorId});

  @override
  State<SensorSearchPageSensorList> createState() =>
      _SensorSearchPageSensorListState();
}

class _SensorSearchPageSensorListState
    extends State<SensorSearchPageSensorList> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _getSensorState(widget.sensorId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var state = snapshot.data!;
            return SensorToggleListElement(
              key: UniqueKey(),
              sensorId: widget.sensorId,
              isDisabled: !state.isAvailable,
              isToggledOn: state.isCurrentlyBeingTracked,
            );
          }

          return SensorToggleListElement(
            sensorId: widget.sensorId,
            isDisabled: false,
            isTogglingDisabled: true,
            isToggledOn: false,
          );
        },
      );
}

Future<_SensorState> _getSensorState(SensorId sensorId) async {
  var isAvailable = await IOManager().isSensorAvailable(sensorId);
  var isCurrentlyBeingTracked = await IOManager()
      .getUsedSensors()
      .then((usedSensorsList) => usedSensorsList.contains(sensorId));
  return _SensorState(
    isAvailable: isAvailable,
    isCurrentlyBeingTracked: isCurrentlyBeingTracked,
  );
}

class _SensorState {
  final bool isAvailable;
  final bool isCurrentlyBeingTracked;

  const _SensorState({
    required this.isAvailable,
    required this.isCurrentlyBeingTracked,
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../favorite_provider.dart';
import 'sensor_toggle_list_element.dart';

/// List element that wraps [SensorToggleListElement] in a [FutureBuilder].
class SensorSearchPageSensorListElement extends StatefulWidget {
  final SensorId sensorId;
  final FavoriteProvider provider;

  const SensorSearchPageSensorListElement({
    super.key,
    required this.sensorId,
    required this.provider,
  });

  @override
  State<SensorSearchPageSensorListElement> createState() =>
      _SensorSearchPageSensorListElementState();
}

class _SensorSearchPageSensorListElementState
    extends State<SensorSearchPageSensorListElement> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _getSensorState(widget.sensorId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var state = snapshot.data!;
            return Slidable(
              enabled: widget.provider.isSlidableEnabled(widget.sensorId),
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                extentRatio: 0.15,
                children: [
                  SlidableAction(
                    borderRadius: BorderRadius.circular(20),
                    foregroundColor: Colors.red,
                    backgroundColor: const Color.fromRGBO(34, 0, 77, 100),
                    icon: widget.provider.isExist(widget.sensorId)
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    onPressed: (context) async {
                      await widget.provider.toggleFavorite(widget.sensorId);
                    },
                  ),
                ],
              ),
              child: Column(
                children: [
                  SensorToggleListElement(
                    key: UniqueKey(),
                    sensorId: widget.sensorId,
                    isDisabled: !state.isAvailable,
                    isToggledOn: state.isCurrentlyBeingTracked,
                  ),
                  const SizedBox(height: 6),
                ],
              ),
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

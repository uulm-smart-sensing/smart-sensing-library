import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../utils.dart';

/// [StatefulWidget] which represents a [Text] and a [Switch] encapsuled in a
/// rounded container.
///
/// The [Text] is filled with the name of the passed [sensorId].
/// The passed colors for the active and the inactive state of the switch are
/// overwritten by the colors for the disabled state when [isDisabled] is true.
class SensorToggleElement extends StatefulWidget {
  final SensorId sensorId;

  /// Called when the user toggles the switch on or off.
  ///
  /// When [isDisabled] is true, [onChanged] won't be called.
  final Function(bool isToggledOn) onChanged;

  /// Color of the rounded container.
  final Color? color;

  /// Whether the switch is toggled on.
  final bool? isToggledOn;

  /// Color of the thumb of the switch when [isToggledOn] is true.
  final Color? activeColor;

  /// Color of the track of the switch when [isToggledOn] is true.
  final Color? activeTrackColor;

  /// Color of the thumb of the switch when [isToggledOn] is false.
  final Color? inactiveColor;

  /// Color of the track of the switch when [isToggledOn] is false.
  final Color? inactiveTrackColor;

  /// Color of the text displaying the [SensorId] name.
  final Color? textColor;

  /// Size of the text displaying the [SensorId] name.
  final double? fontSize;

  /// Whether the switch is disabled.
  final bool isDisabled;

  /// Color of the thumb of the switch when [isDisabled] is true.
  final Color? disabledColor;

  /// Color of the track of the switch when [isDisabled] is true.
  final Color? disabledTrackColor;

  SensorToggleElement({
    required this.sensorId,
    required this.onChanged,
    this.color,
    this.isToggledOn,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveColor,
    this.inactiveTrackColor,
    this.textColor,
    this.fontSize,
    this.isDisabled = false,
    this.disabledColor,
    this.disabledTrackColor,
  }) : super(key: ValueKey(sensorId.name));

  @override
  State<SensorToggleElement> createState() => _SensorToggleElementState();
}

class _SensorToggleElementState extends State<SensorToggleElement> {
  bool? _isToggledOn;

  @override
  void initState() {
    _isToggledOn = widget.isToggledOn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                formatPascalCase(widget.sensorId.name),
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: widget.fontSize,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 6),
              child: SizedBox(
                height: 35,
                child: Switch.adaptive(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: !widget.isDisabled && (_isToggledOn ?? false),
                  activeColor: widget.activeColor,
                  activeTrackColor: widget.activeTrackColor,
                  inactiveThumbColor: widget.isDisabled
                      ? widget.disabledColor
                      : widget.inactiveColor,
                  inactiveTrackColor: widget.isDisabled
                      ? widget.disabledTrackColor
                      : widget.inactiveTrackColor,
                  onChanged: (isToggledOn) {
                    if (widget.isDisabled) {
                      return;
                    }

                    setState(() {
                      _isToggledOn = isToggledOn;
                    });
                    widget.onChanged.call(isToggledOn);
                  },
                ),
              ),
            ),
          ],
        ),
      );
}

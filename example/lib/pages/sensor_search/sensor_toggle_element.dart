import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../formatter/text_formatter.dart';
import '../sensor_settings/sensor_settings_page.dart';

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

  const SensorToggleElement({
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
    super.key,
  });

  @override
  State<SensorToggleElement> createState() => _SensorToggleElementState();
}

class _SensorToggleElementState extends State<SensorToggleElement> {
  bool? _isToggledOn;

  @override
  void initState() {
    super.initState();
    _isToggledOn = widget.isToggledOn;
  }

  @override
  Widget build(BuildContext context) {
    var textContainer = Container(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        formatPascalCase(widget.sensorId.name),
        style: TextStyle(
          color: widget.textColor,
          fontSize: widget.fontSize,
        ),
      ),
    );

    var switchValue = !widget.isDisabled && (_isToggledOn ?? false);
    void switchOnChanged(isToggledOn) {
      if (widget.isDisabled) {
        return;
      }

      setState(() {
        _isToggledOn = isToggledOn;
      });
      widget.onChanged.call(isToggledOn);
    }

    var inactiveTrackColor = widget.isDisabled
        ? widget.disabledTrackColor
        : widget.inactiveTrackColor;
    var switchContainer = Container(
      padding: const EdgeInsets.only(right: 6),
      child: SizedBox(
        height: 40,
        child: Platform.isIOS
            ? CupertinoSwitch(
                value: switchValue,
                onChanged: switchOnChanged,
                activeColor: widget.activeTrackColor,
                thumbColor: widget.isDisabled
                    ? widget.disabledColor
                    : widget.activeColor,
                trackColor: inactiveTrackColor,
              )
            : Switch(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: switchValue,
                activeColor: widget.activeColor,
                activeTrackColor: widget.activeTrackColor,
                inactiveThumbColor: widget.isDisabled
                    ? widget.disabledColor
                    : widget.inactiveColor,
                inactiveTrackColor: inactiveTrackColor,
                onChanged: switchOnChanged,
              ),
      ),
    );

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SensorSettingsPage(sensorId: widget.sensorId),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textContainer,
            switchContainer,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../utils.dart';

class SensorToggleListElement extends StatefulWidget {
  final SensorId _sensorId;
  final Function(bool) _onChanged;
  final Color? _color;
  final bool? _isToggledOn;
  final Color? _activeColor;
  final Color? _activeTrackColor;
  final Color? _inactiveColor;
  final Color? _inactiveTrackColor;
  final Color? _textColor;
  final double? _fontSize;

  const SensorToggleListElement({
    super.key,
    required SensorId sensorId,
    required Function(bool) onChanged,
    Color? color,
    bool? isToggledOn,
    Color? activeColor,
    Color? activeTrackColor,
    Color? inactiveColor,
    Color? inactiveTrackColor,
    Color? textColor,
    double? fontSize,
  })  : _sensorId = sensorId,
        _onChanged = onChanged,
        _color = color,
        _isToggledOn = isToggledOn,
        _activeColor = activeColor,
        _activeTrackColor = activeTrackColor,
        _inactiveColor = inactiveColor,
        _inactiveTrackColor = inactiveTrackColor,
        _textColor = textColor,
        _fontSize = fontSize;

  @override
  State<SensorToggleListElement> createState() =>
      _SensorToggleListElementState();
}

class _SensorToggleListElementState extends State<SensorToggleListElement> {
  bool? _isToggledOn;

  @override
  void initState() {
    _isToggledOn = widget._isToggledOn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: widget._color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                formatPascalCase(widget._sensorId.name),
                style: TextStyle(
                  color: widget._textColor,
                  fontSize: widget._fontSize,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 6),
              child: SizedBox(
                height: 35,
                child: Switch.adaptive(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: _isToggledOn ?? false,
                  activeColor: widget._activeColor,
                  activeTrackColor: widget._activeTrackColor,
                  inactiveThumbColor: widget._inactiveColor,
                  inactiveTrackColor: widget._inactiveTrackColor,
                  onChanged: (isToggledOn) {
                    setState(() {
                      _isToggledOn = isToggledOn;
                    });
                    widget._onChanged.call(isToggledOn);
                  },
                ),
              ),
            ),
          ],
        ),
      );
}

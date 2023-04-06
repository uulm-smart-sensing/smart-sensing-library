import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../utils.dart';

class SensorToggleListElement extends StatefulWidget {
  final SensorId sensorId;
  final Function(bool) onChanged;
  final Color? color;
  final bool? isToggledOn;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveColor;
  final Color? inactiveTrackColor;
  final Color? textColor;
  final double? fontSize;

  SensorToggleListElement({
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
  }) : super(key: ValueKey(sensorId.name));

  @override
  State<SensorToggleListElement> createState() =>
      _SensorToggleListElementState();
}

class _SensorToggleListElementState extends State<SensorToggleListElement> {
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
                formatPascalCase(widget._sensorId.name),
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
                  value: _isToggledOn ?? false,
                  activeColor: widget.activeColor,
                  activeTrackColor: widget.activeTrackColor,
                  inactiveThumbColor: widget.inactiveColor,
                  inactiveTrackColor: widget.inactiveTrackColor,
                  onChanged: (isToggledOn) {
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

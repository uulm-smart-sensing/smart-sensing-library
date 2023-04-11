import 'package:flutter/material.dart';

class PrecisionSlider extends StatefulWidget {
  final int startValue;
  final void Function(int newValue) onChanged;

  const PrecisionSlider({
    super.key,
    required this.startValue,
    required this.onChanged,
  });

  @override
  State<PrecisionSlider> createState() => _PrecisionSliderState();
}

class _PrecisionSliderState extends State<PrecisionSlider> {
  late int sliderValue = widget.startValue;

  @override
  Widget build(BuildContext context) => Slider(
        min: 0,
        max: 10,
        value: sliderValue.toDouble(),
        label: sliderValue.toString(),
        divisions: 10,
        onChanged: (newValue) {
          setState(() {
            sliderValue = newValue.toInt();
          });
          widget.onChanged.call(sliderValue);
        },
      );
}

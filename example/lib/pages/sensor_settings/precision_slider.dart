import 'package:flutter/material.dart';

/// [Slider] to configure the target precision of a sensors output data.
///
/// The user can select a value in [0-9].
class PrecisionSlider extends StatefulWidget {
  /// Start value of the [Slider].
  final int startValue;

  /// Called when the user is selecting a new value for the slider by dragging.
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

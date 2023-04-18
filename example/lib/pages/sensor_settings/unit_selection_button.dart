import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/selection_button.dart';
import '../../unit_string_representation.dart';

/// [SelectionButton] to select the target unit of a sensors output data.
///
/// If the button is selected the color will change and the text is underlined.
class UnitSelectionButton extends Container {
  final void Function() onPressed;
  final Unit unit;
  final bool isSelected;
  final double width;

  UnitSelectionButton({
    super.key,
    required this.onPressed,
    required this.unit,
    required this.isSelected,
    required this.width,
  }) : super(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(255, 218, 188, 255)
                : const Color.fromARGB(255, 23, 27, 137),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SelectionButton(
            width: width,
            height: 60,
            onPressed: onPressed,
            title: unitToUnitStringRepresentation[unit]!,
            isSelected: isSelected,
          ),
        );
}

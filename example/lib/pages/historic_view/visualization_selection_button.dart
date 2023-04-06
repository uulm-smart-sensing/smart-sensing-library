import 'package:flutter/material.dart';

import 'selection_button.dart';

class VisualizationSelectionButton extends SelectionButton {
  VisualizationSelectionButton({
    super.key,
    required super.onPressed,
    required super.title,
    required super.isSelected,
  }) : super(
          width: 50,
          height: 20,
          selectedColor: const Color.fromARGB(255, 218, 188, 255),
        );
}

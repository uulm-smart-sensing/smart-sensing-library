import 'package:flutter/material.dart';

import '../../general_widgets/selection_button.dart';

/// [SelectionButton] that is used for displaying the visualization selection.
class VisualizationSelectionButton extends SelectionButton {
  VisualizationSelectionButton({
    super.key,
    required super.onPressed,
    required super.title,
    required super.isSelected,
  }) : super(
          width: 65,
          height: 20,
          selectedColor: const Color.fromARGB(255, 218, 188, 255),
        );
}

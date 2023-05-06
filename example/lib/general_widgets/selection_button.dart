import 'package:flutter/material.dart';

/// [TextButton] that can be selected.
///
/// If the button is pressed [onPressed] will be called and the [title] will be
/// underlined (if [underlineTitleWhenSelected] is true). If the button is
/// pressed again the button will be deselected.
///
/// When selected, the button will have the text color [selectedColor].
class SelectionButton extends SizedBox {
  /// Called when the underlying [TextButton] is called.
  final void Function() onPressed;

  /// Title of this [SelectionButton].
  final String title;

  /// Whether the button is selected or not. Depending on [selectedColor] and
  /// [underlineTitleWhenSelected] the button will change color and the text
  /// will be underlined if selected.
  final bool isSelected;

  /// Color of the button when [isSelected] is true.
  final Color? selectedColor;

  /// If true, [title] will be underlined when [isSelected] is true.
  final bool underlineTitleWhenSelected;

  SelectionButton({
    required this.onPressed,
    required this.title,
    required this.isSelected,
    this.selectedColor,
    this.underlineTitleWhenSelected = true,
    super.width,
    super.height,
    super.key,
  }) : super(
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              title,
              style: TextStyle(
                decoration: isSelected && underlineTitleWhenSelected
                    ? TextDecoration.underline
                    : null,
                color: isSelected ? selectedColor : null,
                fontSize: 16,
              ),
            ),
          ),
        );
}

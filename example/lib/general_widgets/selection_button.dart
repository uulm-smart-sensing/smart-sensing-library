import 'package:flutter/material.dart';

/// [TextButton] that can be selected.
///
/// If the button is pressed [onPressed] will be called and the [title] will be
/// underlined. If the button is pressed again the button will be deselected
/// again.
/// When selected the button will have the text color [selectedColor].
class SelectionButton extends SizedBox {
  final void Function() onPressed;
  final String title;
  final bool isSelected;
  final Color? selectedColor;

  SelectionButton({
    required super.width,
    required super.height,
    required this.onPressed,
    required this.title,
    required this.isSelected,
    this.selectedColor,
    super.key,
  }) : super(
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              title,
              style: TextStyle(
                decoration: isSelected ? TextDecoration.underline : null,
                color: isSelected ? selectedColor : null,
              ),
            ),
          ),
        );
}

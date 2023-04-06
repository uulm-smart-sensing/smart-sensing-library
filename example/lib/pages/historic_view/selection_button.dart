import 'package:flutter/material.dart';

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

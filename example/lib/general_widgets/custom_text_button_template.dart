import 'package:flutter/material.dart';

/// Same as [TextButton] but with with specified decoration around the button:
/// * Rounded border with radius 20
/// * Color ARGB: (255, 23, 27, 137)
/// * white text color.
///
/// This [CustomTextButtonTemplate] widget can be used as button in the entire
/// app, if an as button recognizable element is needed.
class CustomTextButtonTemplate extends Container {
  /// Child [Widget] of this [CustomTextButtonTemplate] that is displayed inside
  /// the button.
  final Widget textButtonChild;

  /// Called when this [CustomTextButtonTemplate] is pressed.
  final void Function()? onPressed;

  CustomTextButtonTemplate({
    super.key,
    required this.textButtonChild,
    required this.onPressed,
  }) : super(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 23, 27, 137),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextButton(
            onPressed: onPressed,
            child: textButtonChild,
          ),
        );
}

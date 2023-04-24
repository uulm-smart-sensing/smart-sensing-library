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

  /// Optional width of this [CustomTextButtonTemplate].
  ///
  /// If not provided, the widget will take as much width as required.
  final double? width;

  /// If true the height is fixed to `40`, otherwise the widget will take as
  /// much height as required.
  final bool isDense;

  CustomTextButtonTemplate({
    super.key,
    required this.textButtonChild,
    required this.onPressed,
    this.width,
    this.isDense = true,
  }) : super(
          width: width,
          height: isDense ? 40 : null,
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

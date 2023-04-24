import 'package:flutter/material.dart';

import 'custom_text_button_template.dart';

/// Same as [CustomTextButtonTemplate] but with with a [Text] as textButtonChild
///
/// This [CustomTextButton] widget can be used as button in the entire app
/// if an as button recognizable element is needed.
class CustomTextButton extends CustomTextButtonTemplate {
  /// The [text] which is shown on the custom [TextButton]
  final String text;

  /// Custom [TextStyle] of this [CustomTextButton].
  ///
  /// If not provided, a default [TextStyle] will be used.
  final TextStyle? style;

  CustomTextButton({
    super.key,
    super.onPressed,
    super.width,
    super.isDense,
    required this.text,
    this.style,
  }) : super(
          textButtonChild: Text(
            text,
            style: style ??
                const TextStyle(
                  color: Colors.white,
                ),
          ),
        );
}

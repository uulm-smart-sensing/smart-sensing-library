import 'package:flutter/material.dart';

import 'custom_text_button_template.dart';

/// Same as [CustomTextButtonTemplate] but with with a [Text] as textButtonChild
///
/// This [CustomTextButton] widget can be used as button in the entire app
/// if an as button recognizable element is needed.
class CustomTextButton extends StatelessWidget {
  /// The [text] which is shown on the custom [TextButton]
  final String text;

  /// Called when this [CustomTextButton] is pressed.
  final void Function()? onPressed;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => CustomTextButtonTemplate(
        textButtonChild: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        onPressed: onPressed,
      );
}

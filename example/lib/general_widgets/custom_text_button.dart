import 'package:flutter/material.dart';

/// Same as [TextButton] but with with specified decoration around the button:
/// * Rounded border with radius 20
/// * Color ARGB: (255, 23, 27, 137)
/// * white text color.
///
/// This [CustomTextButton ]widget can be used as button in the entire app
/// if an as button recognizable element is needed.
class CustomTextButton extends StatelessWidget {
  /// The [text] which is shown on the custom [TextButton]
  final String text;

  /// The [Function] which is called if this [CustomTextButton]
  /// is pressed.
  final Function()? onPressed;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 23, 27, 137),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
}

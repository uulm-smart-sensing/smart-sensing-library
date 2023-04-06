import 'package:flutter/material.dart';

/// Formats a string in pascalCase so that each word is separated by spaces and
/// is capitalized.
///
/// Example:
/// ```dart
/// formatPascalCase("pascalCaseText"); // results in "Pascal Case Text"
/// ```
String formatPascalCase(String text) => text
    .split(RegExp("(?=[A-Z])"))
    .map(
      (word) =>
          word.characters.first.toUpperCase() + word.characters.skip(1).join(),
    )
    .join(" ");

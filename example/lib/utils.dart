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

/// Formats a string in where each word is separated by spaces and
/// is capitalized to pascalCase equivalent
///
/// Example:
/// ```dart
/// unformatPascalCase("Pascal Case Text"); // results in "pascalCaseText"
/// ```
String unformatPascalCase(String text) {
  var textWithoutWhiteSpaces = text.replaceAll(" ", "");
  return textWithoutWhiteSpaces.characters.first.toLowerCase() +
      textWithoutWhiteSpaces.characters.skip(1).join();
}

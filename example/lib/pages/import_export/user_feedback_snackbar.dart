import 'package:flutter/material.dart';

/// Displays a [SnackBar] showing the [result] of the import (or export) action,
/// so "Success" if no problems occurred or the error message, if something went
/// wrong.
///
/// The [SnackBar] automatically disappears after 5 seconds.
void displayResultInSnackBar(String result, BuildContext context) {
  var snackBar = SnackBar(
    content: Text(result == "" ? "Success" : result),
    duration: const Duration(seconds: 5),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

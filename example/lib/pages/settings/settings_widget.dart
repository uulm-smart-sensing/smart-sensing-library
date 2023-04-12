import 'package:flutter/material.dart';

import 'settings_page.dart';

/// Widget displaying a settings section.
///
/// This means, this widget will display a unit containing
/// a [title] - showing the title of the page
/// a [subtitle] - explaining the page
/// an [icon] - an icon that represent the page
/// as well a [direction] - navigate to the page
///
/// This [SettingsWidget] can be used on the [SettingsPage] to display a
/// Settings.
class SettingsWidget {
  /// The title of the page
  ///
  /// For example 'Sensors'
  final String title;

  /// The subtitle of the page
  ///
  /// For example 'overview of all Sensors'
  final String subtitle;

  /// The icon of the page
  ///
  /// For example 'Icons.sensors'
  final IconData icon;

  /// Navigation of the page
  ///
  /// by clicking on it, the user reaches the 'InformationPage'
  final Widget direction;

  const SettingsWidget({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.direction,
  });
}

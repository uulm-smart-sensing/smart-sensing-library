import 'package:flutter/material.dart';

class SettingsWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget direction;

  const SettingsWidget({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.direction,
  });
}

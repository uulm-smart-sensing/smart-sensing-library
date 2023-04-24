import 'package:flutter/material.dart';

/// Header element of a section of a page.
class SectionHeader extends Container {
  final String title;

  SectionHeader(this.title, {super.key})
      : super(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
        );
}

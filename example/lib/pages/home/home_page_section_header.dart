import 'package:flutter/material.dart';

class HomePageSectionHeader extends StatelessWidget {
  /// Title of this [HomePageSectionHeader].
  final String title;

  /// The callback that is called when this [HomePageSectionHeader] is tapped.
  final void Function() onPressed;

  const HomePageSectionHeader({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onPressed,
        child: Row(
          children: [
            Text(
              title,
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_rounded),
          ],
        ),
      );
}

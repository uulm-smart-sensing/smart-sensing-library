import 'package:flutter/material.dart';

/// [AppBar] with a [Widget] as header in the bottom part of the app bar.
///
/// The header is seperated from the body by a [Divider].
class AppBarWithHeader extends AppBar {
  final String titleText;
  final Widget header;

  AppBarWithHeader({
    super.key,
    required this.header,
    required this.titleText,
  }) : super(
          elevation: 0,
          title: Text(
            titleText,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              child: Column(
                children: [
                  header,
                  const Divider(thickness: 2),
                ],
              ),
            ),
          ),
        );
}

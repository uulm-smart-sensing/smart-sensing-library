import 'package:flutter/material.dart';

class SmartSensingAppBar extends StatelessWidget {
  /// Title of this [AppBar] (= title of the page).
  final String title;

  /// The "subtitle" of this [AppBar].
  ///
  /// The subtitle is like a short description or any additional information,
  /// which should displayed in the header.
  ///
  /// For example the subtitle could be "Gyroscope" on the "Sensor settings"
  /// page for the gyroscope.
  final String subtitle;

  /// The widget used for the body of this [AppBar], so which
  /// should be display on the rest of the page.
  final Widget body;

  const SmartSensingAppBar({
    super.key,
    required this.title,
    this.subtitle = "",
    required this.body,
  });

  /// Create the [Widget] with displays the [subtitle] at the bottom
  /// of this [AppBar].
  Widget _createSubtitle() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          subtitle,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      );

  /// Create a divider, which will be placed at the bottom of this [AppBar].
  Widget _createDivider() => const Divider(
        thickness: 2,
        indent: 15,
        endIndent: 15,
        color: Colors.white,
      );

  /// Create the [PreferredSizeWidget] containing the divider and
  /// if the subtitle is set, also the subtitle widget above the divider.
  ///
  /// This widget will be placed at the bottom of the [AppBar].
  PreferredSizeWidget? _createBottom() {
    // check, whether the subtitle is not emtpy, a subtitle was given
    if (subtitle.isNotEmpty) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Center(
          child: Column(
            children: [_createSubtitle(), _createDivider()],
          ),
        ),
      );
    }

    // if no subtitle was provided, only display the divider
    return PreferredSize(
      preferredSize: const Size.fromHeight(20.0),
      child: Center(
        child: _createDivider(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          bottom: _createBottom(),
        ),
        body: body,
      );
}

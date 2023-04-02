import 'package:flutter/material.dart';

class HomePageSection extends StatelessWidget {
  /// Title of this [HomePageSection].
  final String title;

  /// The callback that is called when the title is tapped.
  final void Function() onPressed;

  /// Axis on which the children are displayed.
  ///
  /// Default value is [Axis.vertical].
  final Axis axis;

  /// Padding space between each [Widget] in [children].
  ///
  /// Default value is zero.
  final double spaceBetweenChildren;

  /// [Widget]s which are listed in this [HomePageSection].
  ///
  /// Default value is an empty list.
  final List<Widget> children;

  const HomePageSection({
    super.key,
    required this.title,
    required this.onPressed,
    this.axis = Axis.vertical,
    this.spaceBetweenChildren = 0,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    var header = MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_rounded),
        ],
      ),
    );

    // Add padding between children
    var bodyElements = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      bodyElements.add(children[i]);
      if (i < children.length - 1) {
        bodyElements.add(
          axis == Axis.horizontal
              ? SizedBox(width: spaceBetweenChildren)
              : SizedBox(height: spaceBetweenChildren),
        );
      }
    }

    var body = Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: axis == Axis.horizontal
          ? Row(children: bodyElements)
          : Column(children: bodyElements),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        body,
      ],
    );
  }
}

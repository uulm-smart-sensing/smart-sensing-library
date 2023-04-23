import 'package:flutter/material.dart';

/// List along a specified [Axis] in which widgets are displayed.
class HomePageSectionBody extends StatelessWidget {
  /// Axis on which the children are displayed and scrolled.
  ///
  /// Default value is [Axis.horizontal].
  final Axis scrollDirection;

  /// Padding space between each [Widget] in [children].
  ///
  /// Default value is 20.
  final double spaceBetweenChildren;

  /// [Widget]s which are listed in this [HomePageSectionBody].
  ///
  /// Default value is an empty list.
  /// It is expected that the children widgets are sensor widgets.
  final List<Widget> children;

  /// Text that is displayed if [children] is empty.
  final String noChildrenText;

  const HomePageSectionBody({
    super.key,
    this.scrollDirection = Axis.horizontal,
    this.spaceBetweenChildren = 20,
    this.children = const [],
    this.noChildrenText = "No elements",
  });

  @override
  Widget build(BuildContext context) {
    // Add padding between children
    var bodyElements = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      bodyElements.add(children[i]);
      if (i < children.length - 1) {
        bodyElements.add(
          scrollDirection == Axis.horizontal
              ? SizedBox(width: spaceBetweenChildren)
              : SizedBox(height: spaceBetweenChildren),
        );
      }
    }

    if (bodyElements.isEmpty) {
      bodyElements.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            noChildrenText,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: scrollDirection,
      child: scrollDirection == Axis.horizontal
          ? Row(children: bodyElements)
          : Column(children: bodyElements),
    );
  }
}

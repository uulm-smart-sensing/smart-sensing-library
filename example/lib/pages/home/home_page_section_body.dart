import 'package:flutter/material.dart';

class HomePageSectionBody extends StatelessWidget {
  /// Axis on which the children are displayed and scrolled.
  ///
  /// Default value is [Axis.vertical].
  final Axis scrollDirection;

  /// Padding space between each [Widget] in [children].
  ///
  /// Default value is zero.
  final double spaceBetweenChildren;

  /// Determines whether this [HomePageSectionBody] should have a fixed size or
  /// take the remaining size of the parent [Widget].
  ///
  /// If this is `true`, [size] has to be set, otherwise [size] will be ignored.
  final bool hasFixedSize;

  /// Size of this [HomePageSectionBody].
  ///
  /// The size applies only to the other opposite [Axis] from [scrollDirection],
  /// i.e. when [scrollDirection] is [Axis.horizontal] the size will be applied
  /// to the vertical axis and vice versa.
  final double size;

  /// [Widget]s which are listed in this [HomePageSectionBody].
  ///
  /// Default value is an empty list.
  /// It is expected that the children widgets are sensor widgets.
  final List<Widget> children;

  const HomePageSectionBody({
    super.key,
    this.scrollDirection = Axis.vertical,
    this.spaceBetweenChildren = 0,
    this.hasFixedSize = false,
    this.size = 0,
    this.children = const [],
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

    // This only works using Container:
    // ignore: sized_box_for_whitespace
    return Container(
      height: hasFixedSize && scrollDirection == Axis.horizontal ? size : null,
      width: hasFixedSize && scrollDirection == Axis.vertical ? size : null,
      child: Expanded(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          physics: const BouncingScrollPhysics(),
          scrollDirection: scrollDirection,
          children: bodyElements,
        ),
      ),
    );
  }
}

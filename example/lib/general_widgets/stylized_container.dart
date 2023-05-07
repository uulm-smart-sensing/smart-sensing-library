import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Same as [Container] but with with specified decoration:
/// * Rounded border with radius 20
/// * Color ARGB: (255, 34, 0, 77)
///
/// This widget can be used to wrap other widgets and provide a purple
/// background which rounded corners for them.
class StylizedContainer extends StatelessWidget {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Widget? child;
  final Clip clipBehavior;

  const StylizedContainer({
    super.key,
    this.alignment,
    this.padding,
    this.color,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.child,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) => Container(
        alignment: alignment,
        padding: padding,
        decoration: BoxDecoration(
          color: color ?? secondaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        foregroundDecoration: foregroundDecoration,
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        transform: transform,
        transformAlignment: transformAlignment,
        clipBehavior: clipBehavior,
        child: child,
      );
}

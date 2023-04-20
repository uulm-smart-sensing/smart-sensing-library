import 'package:flutter/material.dart';
import 'stylized_container.dart';

/// This is a specialized clickable [StylizedContainer].
/// Basesize is 150.
class BrickContainer extends StatelessWidget {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final Function()? onClick;
  final Widget? child;
  final EdgeInsets? padding;
  final Color? color;

  const BrickContainer({
    super.key,
    this.onClick,
    this.height = 150,
    this.width = 150,
    this.child,
    this.padding,
    this.color,
    this.alignment,
    this.margin,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onClick,
        child: StylizedContainer(
          padding: padding,
          alignment: alignment ?? Alignment.center,
          margin: margin,
          width: width,
          height: height,
          color: color,
          child: child,
        ),
      );
}

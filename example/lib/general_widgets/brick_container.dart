import 'package:flutter/material.dart';
import 'stylized_container.dart';

///This is a specialized square clickable [StylizedContainer].
class BrickContainer extends StatelessWidget {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? margin;
  final double? size;
  final Function()? onClick;
  final Widget? child;
  final EdgeInsets? padding;
  final Color? color;

  const BrickContainer({
    super.key,
    this.onClick,
    this.size = 150,
    this.child,
    this.padding,
    this.color, this.alignment, this.margin,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onClick,
        child: StylizedContainer(
          padding: padding,
          alignment: alignment ?? Alignment.center,
          margin: margin,
          width: size,
          height: size,
          color: color,
          child: child,
        ),
      );
}

import 'package:flutter/material.dart';

import 'stylized_container.dart';

class BrickContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Function()? onClick;
  final Widget? child;
  final EdgeInsets? padding;

  const BrickContainer({
    super.key,
    this.onClick,
    this.height = 150,
    this.width = 150,
    this.child, this.padding,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onClick,
        child: StylizedContainer(
          padding: padding,
          alignment: Alignment.center,
          width: width,
          height: height,
          child: child,
        ),
      );
}



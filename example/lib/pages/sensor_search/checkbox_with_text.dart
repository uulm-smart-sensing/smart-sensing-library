import 'package:flutter/material.dart';

import '../../theme.dart';

class CheckBoxWithText extends StatefulWidget {
  final String text;
  final bool isChecked;
  final void Function(bool isChecked) onPressed;

  const CheckBoxWithText({
    super.key,
    required this.text,
    required this.isChecked,
    required this.onPressed,
  });

  @override
  State<CheckBoxWithText> createState() => _CheckBoxWithTextState();
}

class _CheckBoxWithTextState extends State<CheckBoxWithText> {
  late bool isChecked = widget.isChecked;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(
            widget.text,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            child: SizedBox.square(
              dimension: 30,
              child: Container(
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isChecked
                    ? const Icon(Icons.check)
                    : const SizedBox.shrink(),
              ),
            ),
            onTapDown: (details) {
              setState(() {
                isChecked = !isChecked;
                widget.onPressed.call(isChecked);
              });
            },
          ),
        ],
      );
}

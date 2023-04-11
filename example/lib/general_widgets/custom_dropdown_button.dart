import 'package:flutter/material.dart';

import 'stylized_container.dart';

class CustomDropdownButton<T> extends StylizedContainer {
  final String hint;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T? newValue) onChanged;
  final bool isDense;

  CustomDropdownButton({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.isDense,
  }) : super(
          padding:
              EdgeInsets.symmetric(horizontal: 15, vertical: isDense ? 3 : 0),
          child: DropdownButton(
            isExpanded: true,
            isDense: isDense,
            underline: const SizedBox.shrink(),
            borderRadius: BorderRadius.circular(20),
            dropdownColor: const Color.fromARGB(255, 34, 0, 77),
            hint: Text(
              hint,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            iconSize: 30,
            iconEnabledColor: Colors.white,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            value: value,
            items: items,
            onChanged: onChanged,
          ),
        );
}

import 'package:flutter/material.dart';

import '../theme.dart';
import 'stylized_container.dart';

/// A customized [DropdownButton] that is wrapped by a [StylizedContainer].
///
/// The customization includes:
/// * taking the full width of the parent widget
/// * both the [DropdownButton] and the [DropdownMenu] have a rounded shape and
/// the purple theme color
/// * [Icons.keyboard_arrow_down_rounded] is used as icon
class CustomDropdownButton<T> extends StylizedContainer {
  /// The text being displayed when no [DropdownMenuItem] is selected / when
  /// [value] is null.
  final String hint;

  /// The value of the currently selected [DropdownMenuItem].
  ///
  /// When [value] is null, i.e. no [DropdownMenuItem] is selected, the [hint]
  /// is displayed.
  final T value;

  /// The list of items the user can choose from when pressing this button.
  final List<DropdownMenuItem<T>> items;

  /// Called when the user selects an item.
  final void Function(T? newValue) onChanged;

  /// Reduces the height of this button.
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
            dropdownColor: secondaryColor,
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

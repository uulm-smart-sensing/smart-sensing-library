import 'selection_button.dart';

/// [SelectionButton] that is used for displaying the time selection.
class TimeSelectionButton extends SelectionButton {
  TimeSelectionButton({
    super.key,
    required super.onPressed,
    required super.title,
    required super.isSelected,
  }) : super(
          width: 50,
          height: 35,
        );
}

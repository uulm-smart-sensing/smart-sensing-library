import 'selection_button.dart';

class VisualizationSelectionButton extends SelectionButton {
  VisualizationSelectionButton({
    super.key,
    required super.onPressed,
    required super.title,
    required super.isSelected,
  }) : super(
          width: 50,
          height: 20,
        );
}

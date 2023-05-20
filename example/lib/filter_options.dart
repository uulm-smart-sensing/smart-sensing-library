import 'package:smart_sensing_library/filter_tools.dart';

/// Enum that represents ever [FilterOption] of [FilterTools].
enum FilterOption {
  /// Represents the maximum filter from [FilterTools].
  max(axisNumber: 3, shortText: "Max"),
  /// Represents the minimum filter from [FilterTools].
  min(axisNumber: 3, shortText: "Min"),
  /// Represents the average filter from [FilterTools].
  avg(axisNumber: 1, shortText: "Avg"),
  /// Represents the standard deviation filter from [FilterTools].
  sd(axisNumber: 1, shortText: "Standard dev."),
  /// Represents the mode filter from [FilterTools].
  mode(axisNumber: 3, shortText: "Mode"),
  /// Represents the range filter from [FilterTools].
  range(axisNumber: 1, shortText: "Range"),
  /// Represents the median filter from [FilterTools].
  median(axisNumber: 1, shortText: "Median"),
  /// Represents the sum filter from [FilterTools].
  sum(axisNumber: 1, shortText: "Sum"),
  ;

  const FilterOption({
    required this.axisNumber,
    required this.shortText,
  });

  final num axisNumber;
  final String shortText;
}

import 'package:smart_sensing_library/filter_tools.dart';

/// Enum that represents ever [FilterOption] of [FilterTools].
///
/// Has a [axisNumber] that represents the number of axes that can be chosen.
/// Has [shortText] that returns the filter as a [String].
enum FilterOption {
  /// Represents the maximum filter from [FilterTools].
  ///
  /// Axis number is 3.
  max(axisNumber: 3, shortText: "Max"),
  /// Represents the minimum filter from [FilterTools].
  ///
  /// Axis number is 3.
  min(axisNumber: 3, shortText: "Min"),
  /// Represents the average filter from [FilterTools].
  ///
  /// Axis number is 1.
  avg(axisNumber: 1, shortText: "Avg"),
  /// Represents the standard deviation filter from [FilterTools].
  ///
  /// Axis number is 1.
  sd(axisNumber: 1, shortText: "Standard dev."),
  /// Represents the mode filter from [FilterTools].
  ///
  /// Axis number is 3.
  mode(axisNumber: 3, shortText: "Mode"),
  /// Represents the range filter from [FilterTools].
  ///
  /// Axis number is 1.
  range(axisNumber: 1, shortText: "Range"),
  /// Represents the median filter from [FilterTools].
  ///
  /// Axis number is 1.
  median(axisNumber: 1, shortText: "Median"),
  /// Represents the sum filter from [FilterTools].
  ///
  /// Axis number is 1.
  sum(axisNumber: 1, shortText: "Sum"),
  ;

  const FilterOption({
    required this.axisNumber,
    required this.shortText,
  });

  final num axisNumber;
  final String shortText;
}

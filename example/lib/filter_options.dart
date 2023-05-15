enum FilterOption {
  max(axisNumber: 3, shortText: "Max"),
  min(axisNumber: 3, shortText: "Min"),
  avg(axisNumber: 1, shortText: "Avg"),
  sd(axisNumber: 1, shortText: "Standard dev."),
  mode(axisNumber: 3, shortText: "Mode"),
  range(axisNumber: 1, shortText: "Range"),
  median(axisNumber: 1, shortText: "Median"),
  sum(axisNumber: 1, shortText: "Sum"),
  ;

  const FilterOption({
    required this.axisNumber,
    required this.shortText,
  });

  final num axisNumber;
  final String shortText;
}

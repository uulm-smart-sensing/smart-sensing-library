enum FilterOption {
  max(axisNumber: 3, shortText: "Max"),
  min(axisNumber: 3, shortText: "Min"),
  avg(axisNumber: 1, shortText: "Avg"),
  sd(axisNumber: 1, shortText: "Standard dev.");

  const FilterOption({
    required this.axisNumber,
    required this.shortText,
  });

  final num axisNumber;
  final String shortText;
}

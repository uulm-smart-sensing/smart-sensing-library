enum FilterOptions {
  max(axisRequirement: true, shortText: "Max"),
  min(axisRequirement: true, shortText: "Min"),
  avg(axisRequirement: false, shortText: "Avg"),
  sd(axisRequirement: false, shortText: "Standard dev.");



  const FilterOptions({
    required this.axisRequirement,
    required this.shortText,
  });

  final bool axisRequirement;
  final String shortText;
}

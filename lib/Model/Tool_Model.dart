class ToolCategory {
  final String name;
  final String nameHindi;
  final String icon;
  final List<ToolInfo> tools;

  ToolCategory({
    required this.name,
    required this.nameHindi,
    required this.icon,
    required this.tools,
  });
}

class ToolInfo {
  final String name;
  final String nameHindi;
  final String image;
  final String description;
  final String descriptionHindi;
  final String usage;
  final String usageHindi;
  final String maintenance;
  final String maintenanceHindi;
  final String priceRange;
  final String priceRangeHindi;
  final String bestFor;
  final String bestForHindi;
  final String safetyTips;
  final String safetyTipsHindi;
  final String videoUrl;

  ToolInfo({
    required this.name,
    required this.nameHindi,
    required this.image,
    required this.description,
    required this.descriptionHindi,
    required this.usage,
    required this.usageHindi,
    required this.maintenance,
    required this.maintenanceHindi,
    required this.priceRange,
    required this.priceRangeHindi,
    required this.bestFor,
    required this.bestForHindi,
    required this.safetyTips,
    required this.safetyTipsHindi,
    this.videoUrl = '',
  });
}

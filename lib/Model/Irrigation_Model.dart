class IrrigationCategory {
  final String name;
  final String nameHindi;
  final String icon;
  final List<IrrigationInfo> methods;

  IrrigationCategory({
    required this.name,
    required this.nameHindi,
    required this.icon,
    required this.methods,
  });
}

class IrrigationInfo {
  final String name;
  final String nameHindi;
  final String image;
  final String description;
  final String descriptionHindi;
  final String howToUse;
  final String howToUseHindi;
  final String advantages;
  final String advantagesHindi;
  final String disadvantages;
  final String disadvantagesHindi;
  final String suitableCrops;
  final String suitableCropsHindi;
  final String waterEfficiency;
  final String waterEfficiencyHindi;
  final String cost;
  final String costHindi;
  final String videoUrl;

  IrrigationInfo({
    required this.name,
    required this.nameHindi,
    required this.image,
    required this.description,
    required this.descriptionHindi,
    required this.howToUse,
    required this.howToUseHindi,
    required this.advantages,
    required this.advantagesHindi,
    required this.disadvantages,
    required this.disadvantagesHindi,
    required this.suitableCrops,
    required this.suitableCropsHindi,
    required this.waterEfficiency,
    required this.waterEfficiencyHindi,
    required this.cost,
    required this.costHindi,
    this.videoUrl = '',
  });
}

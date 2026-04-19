class SeedCategory {
  final String name;
  final String nameHindi;
  final String icon;
  final List<SeedInfo> seeds;

  SeedCategory({
    required this.name,
    required this.nameHindi,
    required this.icon,
    required this.seeds,
  });
}

class SeedInfo {
  final String name;
  final String nameHindi;
  final String image;
  final String description;
  final String descriptionHindi;
  final String season;
  final String seasonHindi;
  final String sowingTime;
  final String sowingTimeHindi;
  final String soilType;
  final String soilTypeHindi;
  final String seedRate;
  final String seedRateHindi;
  final String fieldPreparation;
  final String fieldPreparationHindi;
  final String sowingMethod;
  final String sowingMethodHindi;
  final String irrigation;
  final String irrigationHindi;
  final String fertilizer;
  final String fertilizerHindi;
  final String pestControl;
  final String pestControlHindi;
  final String diseaseControl;
  final String diseaseControlHindi;
  final String harvesting;
  final String harvestingHindi;
  final String yield;
  final String yieldHindi;
  final String videoUrl;

  SeedInfo({
    required this.name,
    required this.nameHindi,
    required this.image,
    required this.description,
    required this.descriptionHindi,
    required this.season,
    required this.seasonHindi,
    required this.sowingTime,
    required this.sowingTimeHindi,
    required this.soilType,
    required this.soilTypeHindi,
    required this.seedRate,
    required this.seedRateHindi,
    required this.fieldPreparation,
    required this.fieldPreparationHindi,
    required this.sowingMethod,
    required this.sowingMethodHindi,
    required this.irrigation,
    required this.irrigationHindi,
    required this.fertilizer,
    required this.fertilizerHindi,
    required this.pestControl,
    required this.pestControlHindi,
    required this.diseaseControl,
    required this.diseaseControlHindi,
    required this.harvesting,
    required this.harvestingHindi,
    required this.yield,
    required this.yieldHindi,
    this.videoUrl = '',
  });
}

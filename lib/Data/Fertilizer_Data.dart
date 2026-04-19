class FertilizerItem {
  final String name;
  final String nameHindi;
  final String image;

  FertilizerItem({
    required this.name,
    required this.nameHindi,
    required this.image,
  });
}

class FertilizerData {
  static List<FertilizerItem> getAllFertilizers() {
    return [
      FertilizerItem(
        name: 'Urea',
        nameHindi: 'यूरिया',
        image: '⚗️',
      ),
      FertilizerItem(
        name: 'DAP',
        nameHindi: 'डीएपी',
        image: '💠',
      ),
      FertilizerItem(
        name: 'Compost',
        nameHindi: 'कम्पोस्ट',
        image: '♻️',
      ),
      FertilizerItem(
        name: 'NPK',
        nameHindi: 'एनपीके',
        image: '🌱',
      ),
      FertilizerItem(
        name: 'SSP',
        nameHindi: 'एसएसपी',
        image: '🪨',
      ),
      FertilizerItem(
        name: 'MOP',
        nameHindi: 'एमओपी',
        image: '💎',
      ),
      FertilizerItem(
        name: 'Zinc Sulphate',
        nameHindi: 'जिंक सल्फेट',
        image: '🔬',
      ),
      FertilizerItem(
        name: 'Vermicompost',
        nameHindi: 'वर्मीकम्पोस्ट',
        image: '🪱',
      ),
      FertilizerItem(
        name: 'Gypsum',
        nameHindi: 'जिप्सम',
        image: '🪨',
      ),
      FertilizerItem(
        name: 'Bone Meal',
        nameHindi: 'हड्डी का चूरा',
        image: '🦴',
      ),
      FertilizerItem(
        name: 'Neem Cake',
        nameHindi: 'नीम खली',
        image: '🌿',
      ),
      FertilizerItem(
        name: 'Ammonium Sulphate',
        nameHindi: 'अमोनियम सल्फेट',
        image: '🧪',
      ),
    ];
  }
}

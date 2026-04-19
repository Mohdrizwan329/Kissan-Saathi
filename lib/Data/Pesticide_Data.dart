class PesticideItem {
  final String name;
  final String nameHindi;
  final String image;

  PesticideItem({
    required this.name,
    required this.nameHindi,
    required this.image,
  });
}

class PesticideData {
  static List<PesticideItem> getAllPesticides() {
    return [
      PesticideItem(
        name: 'Neem Oil',
        nameHindi: 'नीम का तेल',
        image: '🫙',
      ),
      PesticideItem(
        name: 'Chlorpyrifos',
        nameHindi: 'क्लोरपायरीफॉस',
        image: '🫗',
      ),
      PesticideItem(
        name: 'Imidacloprid',
        nameHindi: 'इमिडाक्लोप्रिड',
        image: '💊',
      ),
      PesticideItem(
        name: 'Mancozeb',
        nameHindi: 'मैन्कोज़ेब',
        image: '🏺',
      ),
      PesticideItem(
        name: 'Carbendazim',
        nameHindi: 'कार्बेन्डाज़िम',
        image: '🧫',
      ),
      PesticideItem(
        name: 'Cypermethrin',
        nameHindi: 'साइपरमेथ्रिन',
        image: '🐛',
      ),
      PesticideItem(
        name: 'Sulphur',
        nameHindi: 'गंधक',
        image: '🌋',
      ),
      PesticideItem(
        name: 'Trichoderma',
        nameHindi: 'ट्राइकोडर्मा',
        image: '🍄',
      ),
      PesticideItem(
        name: 'Beauveria',
        nameHindi: 'ब्यूवेरिया',
        image: '🦠',
      ),
      PesticideItem(
        name: 'Copper Oxy',
        nameHindi: 'कॉपर ऑक्सी',
        image: '🔶',
      ),
      PesticideItem(
        name: 'Thiram',
        nameHindi: 'थीरम',
        image: '🛡️',
      ),
      PesticideItem(
        name: 'Malathion',
        nameHindi: 'मैलाथियॉन',
        image: '🐜',
      ),
    ];
  }
}

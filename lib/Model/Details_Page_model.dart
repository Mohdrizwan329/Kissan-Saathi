class DetailsPage {
  // final int id;
  final String name;
  final String description;
  final String subDescription;
  final String stock;
  final String rating;
  final String offer;
  final double price;
  final dynamic Image;
  final double subPrice;
  int quantity;

  DetailsPage({
    required this.name,
    required this.price,
    required this.Image,
    this.quantity = 0,
    this.subPrice = 0,
    required this.subDescription,
    required this.description,
    required this.offer,
    required this.rating,
    required this.stock,
  });
}

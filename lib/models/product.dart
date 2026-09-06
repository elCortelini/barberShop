class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category; // Pomadas, Óleos, Shampoos, Cuidado
  final String imageUrl;
  final Map<String, int> stockByBranch; // branchId -> quantidade
  final int loyaltyPointsBonus;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.stockByBranch,
    this.loyaltyPointsBonus = 15,
  });
}

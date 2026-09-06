class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final Map<String, int> stockByBranch;
  final int loyaltyPointsBonus;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.stockByBranch,
    this.loyaltyPointsBonus = 15,
    this.isAvailable = true,
  });

  Product copyWith({
    String? name,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
    Map<String, int>? stockByBranch,
    int? loyaltyPointsBonus,
    bool? isAvailable,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      stockByBranch: stockByBranch ?? this.stockByBranch,
      loyaltyPointsBonus: loyaltyPointsBonus ?? this.loyaltyPointsBonus,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

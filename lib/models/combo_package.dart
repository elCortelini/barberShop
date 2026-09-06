class ComboPackage {
  final String id;
  final String title;
  final String description;
  final double originalPrice;
  final double packagePrice;
  final List<String> serviceNames;
  final List<String> productNames;
  final int bonusPoints;
  final String badgeText;
  final String imageUrl;
  final bool isAvailable;

  ComboPackage({
    required this.id,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.packagePrice,
    required this.serviceNames,
    required this.productNames,
    this.bonusPoints = 60,
    this.badgeText = 'PACOTE ELITE',
    this.imageUrl = '',
    this.isAvailable = true,
  });

  double get discountPercent =>
      ((originalPrice - packagePrice) / originalPrice) * 100;

  ComboPackage copyWith({
    String? title,
    String? description,
    double? originalPrice,
    double? packagePrice,
    List<String>? serviceNames,
    List<String>? productNames,
    int? bonusPoints,
    String? badgeText,
    String? imageUrl,
    bool? isAvailable,
  }) {
    return ComboPackage(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      originalPrice: originalPrice ?? this.originalPrice,
      packagePrice: packagePrice ?? this.packagePrice,
      serviceNames: serviceNames ?? this.serviceNames,
      productNames: productNames ?? this.productNames,
      bonusPoints: bonusPoints ?? this.bonusPoints,
      badgeText: badgeText ?? this.badgeText,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

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
  });

  double get discountPercent =>
      ((originalPrice - packagePrice) / originalPrice) * 100;
}

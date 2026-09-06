class ServiceItem {
  final String id;
  final String title;
  final String description;
  final double price;
  final int durationMinutes;
  final String category;
  final String iconName;
  final String imageUrl;
  final List<String> availableBranchIds;
  final List<String> professionalIds; // Barbeiros que realizam o serviço

  ServiceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.category,
    this.iconName = 'content_cut',
    this.imageUrl = '',
    this.availableBranchIds = const [],
    this.professionalIds = const [],
  });

  ServiceItem copyWith({
    String? title,
    String? description,
    double? price,
    int? durationMinutes,
    String? category,
    String? iconName,
    String? imageUrl,
    List<String>? availableBranchIds,
    List<String>? professionalIds,
  }) {
    return ServiceItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      category: category ?? this.category,
      iconName: iconName ?? this.iconName,
      imageUrl: imageUrl ?? this.imageUrl,
      availableBranchIds: availableBranchIds ?? this.availableBranchIds,
      professionalIds: professionalIds ?? this.professionalIds,
    );
  }
}

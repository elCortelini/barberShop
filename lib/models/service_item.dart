class ServiceItem {
  final String id;
  final String title;
  final String description;
  final double price;
  final int durationMinutes;
  final String category; // Cabelo, Barba, Tratamento, Estética
  final String iconName;
  final List<String> availableBranchIds; // Vazio = todas as filiais

  ServiceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.category,
    this.iconName = 'content_cut',
    this.availableBranchIds = const [],
  });
}

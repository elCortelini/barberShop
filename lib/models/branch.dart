class Branch {
  final String id;
  final String name; // e.g. "Estação Elite - Matriz Centro", "Estação Elite - Filial Shopping"
  final String address;
  final String phone;
  final bool isMain; // Matriz vs Filial
  final String openingHours;
  final String imageUrl;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.isMain = false,
    required this.openingHours,
    required this.imageUrl,
  });
}

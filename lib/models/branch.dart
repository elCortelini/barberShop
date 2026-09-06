class Branch {
  final String id;
  final String name; // e.g. "Estação Elite - Matriz Centro", "Estação Elite - Filial Shopping"
  final String address;
  final String phone;
  final bool isMain; // Matriz vs Filial
  final String openingHours;
  final String imageUrl;
  final List<String> managerEmails; // E-mails dos gerentes/donos autorizados

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.isMain = false,
    required this.openingHours,
    required this.imageUrl,
    this.managerEmails = const [],
  });

  Branch copyWith({
    List<String>? managerEmails,
  }) {
    return Branch(
      id: id,
      name: name,
      address: address,
      phone: phone,
      isMain: isMain,
      openingHours: openingHours,
      imageUrl: imageUrl,
      managerEmails: managerEmails ?? this.managerEmails,
    );
  }
}

class Professional {
  final String id;
  final String name;
  final String email;
  final String role;
  final String avatarUrl;
  final double rating;
  final List<String> branchIds;
  final List<String> serviceIds; // Tipos de serviços executados
  final String workingHours; // e.g. "08:00 - 19:00"
  final List<int> workingDays;
  final List<String> availableTimeSlots;
  final String bio;

  Professional({
    required this.id,
    required this.name,
    this.email = '',
    required this.role,
    required this.avatarUrl,
    required this.rating,
    required this.branchIds,
    this.serviceIds = const [],
    this.workingHours = '08:00 - 19:00',
    required this.workingDays,
    required this.availableTimeSlots,
    required this.bio,
  });

  Professional copyWith({
    String? name,
    String? email,
    String? role,
    String? avatarUrl,
    double? rating,
    List<String>? branchIds,
    List<String>? serviceIds,
    String? workingHours,
    List<int>? workingDays,
    List<String>? availableTimeSlots,
    String? bio,
  }) {
    return Professional(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rating: rating ?? this.rating,
      branchIds: branchIds ?? this.branchIds,
      serviceIds: serviceIds ?? this.serviceIds,
      workingHours: workingHours ?? this.workingHours,
      workingDays: workingDays ?? this.workingDays,
      availableTimeSlots: availableTimeSlots ?? this.availableTimeSlots,
      bio: bio ?? this.bio,
    );
  }
}

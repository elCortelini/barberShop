class Professional {
  final String id;
  final String name;
  final String role; // Master Barber, Especialista Barba, Visagista
  final String avatarUrl;
  final double rating;
  final List<String> branchIds;
  final List<int> workingDays; // 1 = Seg, 7 = Dom
  final List<String> availableTimeSlots;
  final String bio;

  Professional({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.rating,
    required this.branchIds,
    required this.workingDays,
    required this.availableTimeSlots,
    required this.bio,
  });
}

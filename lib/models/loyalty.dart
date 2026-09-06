class LoyaltyReward {
  final String id;
  final String title;
  final String description;
  final int pointsRequired;
  final String category;

  LoyaltyReward({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsRequired,
    required this.category,
  });
}

class LoyaltyTransaction {
  final String id;
  final String title;
  final int points;
  final DateTime date;
  final bool isEarned;

  LoyaltyTransaction({
    required this.id,
    required this.title,
    required this.points,
    required this.date,
    required this.isEarned,
  });
}

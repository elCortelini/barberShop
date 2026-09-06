enum AppointmentStatus { scheduled, completed, cancelled }

class Appointment {
  final String id;
  final String branchId;
  final String branchName;
  final String professionalId;
  final String professionalName;
  final String serviceOrPackageTitle;
  final double price;
  final DateTime dateTime;
  final String timeSlot;
  final AppointmentStatus status;
  final bool reminderEnabled;
  final int loyaltyPointsEarned;

  Appointment({
    required this.id,
    required this.branchId,
    required this.branchName,
    required this.professionalId,
    required this.professionalName,
    required this.serviceOrPackageTitle,
    required this.price,
    required this.dateTime,
    required this.timeSlot,
    this.status = AppointmentStatus.scheduled,
    this.reminderEnabled = true,
    this.loyaltyPointsEarned = 30,
  });

  Appointment copyWith({
    AppointmentStatus? status,
    bool? reminderEnabled,
  }) {
    return Appointment(
      id: id,
      branchId: branchId,
      branchName: branchName,
      professionalId: professionalId,
      professionalName: professionalName,
      serviceOrPackageTitle: serviceOrPackageTitle,
      price: price,
      dateTime: dateTime,
      timeSlot: timeSlot,
      status: status ?? this.status,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      loyaltyPointsEarned: loyaltyPointsEarned,
    );
  }
}

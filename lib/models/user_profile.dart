enum UserRole { client, barberProfessional, storeOwner, superAdmin }

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final UserRole role;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.role,
  });

  String get roleDisplayName {
    switch (role) {
      case UserRole.superAdmin:
        return 'SUPER ADMINISTRADOR';
      case UserRole.storeOwner:
        return 'DONO / GERENTE DE LOJA';
      case UserRole.barberProfessional:
        return 'PROFISSIONAL BARBEIRO';
      case UserRole.client:
        return 'CLIENTE ELITE';
    }
  }

  bool get isSuperAdmin => role == UserRole.superAdmin;
  bool get isStoreOwner => role == UserRole.storeOwner || role == UserRole.superAdmin;
  bool get isBarberProfessional => role == UserRole.barberProfessional;
  bool get isClient => role == UserRole.client;
}

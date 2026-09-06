import 'package:flutter/material.dart';
import '../models/branch.dart';
import '../models/service_item.dart';
import '../models/professional.dart';
import '../models/product.dart';
import '../models/combo_package.dart';
import '../models/appointment.dart';
import '../models/loyalty.dart';
import '../models/promo_banner.dart';
import '../models/user_profile.dart';

class BarbershopProvider extends ChangeNotifier {
  // Super Admin fixed master email
  static const String superAdminEmail = 'elcortelini@gmail.com';

  // Current logged in user
  late UserProfile _currentUser;

  // Data lists
  final List<Branch> _branches = [];
  final List<ServiceItem> _services = [];
  final List<Professional> _professionals = [];
  final List<Product> _products = [];
  final List<ComboPackage> _packages = [];
  final List<Appointment> _appointments = [];
  final List<LoyaltyReward> _loyaltyRewards = [];
  final List<LoyaltyTransaction> _loyaltyTransactions = [];
  final List<PromoBanner> _promoBanners = [];

  // Active branch selected by user
  late Branch _selectedBranch;

  // Loyalty user state
  int _userLoyaltyPoints = 280;

  BarbershopProvider() {
    _initInitialData();
  }

  // Getters
  UserProfile get currentUser => _currentUser;
  Branch get selectedBranch => _selectedBranch;
  List<Branch> get branches => List.unmodifiable(_branches);
  List<ServiceItem> get services => List.unmodifiable(_services);
  List<Professional> get professionals => List.unmodifiable(_professionals);
  List<Product> get products => List.unmodifiable(_products);
  List<ComboPackage> get packages => List.unmodifiable(_packages);
  List<Appointment> get appointments => List.unmodifiable(_appointments);
  List<LoyaltyReward> get loyaltyRewards => List.unmodifiable(_loyaltyRewards);
  List<LoyaltyTransaction> get loyaltyTransactions => List.unmodifiable(_loyaltyTransactions);
  List<PromoBanner> get promoBanners => List.unmodifiable(_promoBanners);
  int get userLoyaltyPoints => _userLoyaltyPoints;

  // Filtered Getters by current branch
  List<Professional> get currentBranchProfessionals {
    return _professionals
        .where((p) => p.branchIds.contains(_selectedBranch.id))
        .toList();
  }

  List<ServiceItem> get currentBranchServices {
    return _services
        .where((s) => s.availableBranchIds.isEmpty || s.availableBranchIds.contains(_selectedBranch.id))
        .toList();
  }

  List<Appointment> get activeAppointments {
    return _appointments
        .where((a) => a.status == AppointmentStatus.scheduled)
        .toList();
  }

  // Roles & Permissions helper
  bool get isSuperAdmin => _currentUser.role == UserRole.superAdmin;
  bool get isStoreOwner => _currentUser.role == UserRole.storeOwner || isSuperAdmin;
  bool get isClient => _currentUser.role == UserRole.client;

  // Authenticaton & Google Login
  void loginWithGoogle({required String email, String? name}) {
    final cleanEmail = email.trim().toLowerCase();
    final displayName = name ?? (cleanEmail.contains('@') ? cleanEmail.split('@').first : cleanEmail);

    UserRole resolvedRole = UserRole.client;

    if (cleanEmail == superAdminEmail.toLowerCase()) {
      resolvedRole = UserRole.superAdmin;
    } else {
      // Check if this email is assigned as a manager to any branch
      final isManager = _branches.any((b) =>
          b.managerEmails.any((m) => m.toLowerCase() == cleanEmail));
      if (isManager) {
        resolvedRole = UserRole.storeOwner;
      }
    }

    _currentUser = UserProfile(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: displayName,
      email: cleanEmail,
      photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      role: resolvedRole,
    );

    notifyListeners();
  }

  void logout() {
    loginWithGoogle(email: 'cliente.demo@gmail.com', name: 'Cliente Demonstração');
  }

  // Super Admin: Assign manager email to branch
  void assignManagerToBranch(String branchId, String managerEmail) {
    final cleanEmail = managerEmail.trim().toLowerCase();
    final idx = _branches.indexWhere((b) => b.id == branchId);
    if (idx != -1) {
      final currentList = List<String>.from(_branches[idx].managerEmails);
      if (!currentList.contains(cleanEmail)) {
        currentList.add(cleanEmail);
        _branches[idx] = _branches[idx].copyWith(managerEmails: currentList);

        // If logged-in user email was assigned, update current role
        if (_currentUser.email.toLowerCase() == cleanEmail && _currentUser.role != UserRole.superAdmin) {
          _currentUser = UserProfile(
            id: _currentUser.id,
            name: _currentUser.name,
            email: _currentUser.email,
            photoUrl: _currentUser.photoUrl,
            role: UserRole.storeOwner,
          );
        }

        notifyListeners();
      }
    }
  }

  // Super Admin: Remove manager email from branch
  void removeManagerFromBranch(String branchId, String managerEmail) {
    final cleanEmail = managerEmail.trim().toLowerCase();
    final idx = _branches.indexWhere((b) => b.id == branchId);
    if (idx != -1) {
      final currentList = List<String>.from(_branches[idx].managerEmails);
      currentList.removeWhere((e) => e.toLowerCase() == cleanEmail);
      _branches[idx] = _branches[idx].copyWith(managerEmails: currentList);

      // Reevaluate current user role if affected
      if (_currentUser.email.toLowerCase() == cleanEmail && _currentUser.role != UserRole.superAdmin) {
        final stillManager = _branches.any((b) =>
            b.managerEmails.any((m) => m.toLowerCase() == cleanEmail));
        if (!stillManager) {
          _currentUser = UserProfile(
            id: _currentUser.id,
            name: _currentUser.name,
            email: _currentUser.email,
            photoUrl: _currentUser.photoUrl,
            role: UserRole.client,
          );
        }
      }

      notifyListeners();
    }
  }

  // Setters & Actions
  void setSelectedBranch(Branch branch) {
    _selectedBranch = branch;
    notifyListeners();
  }

  // Booking action
  void addAppointment({
    required String professionalId,
    required String professionalName,
    required String serviceOrPackageTitle,
    required double price,
    required DateTime date,
    required String timeSlot,
    int pointsEarned = 30,
  }) {
    final newAppointment = Appointment(
      id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
      branchId: _selectedBranch.id,
      branchName: _selectedBranch.name,
      professionalId: professionalId,
      professionalName: professionalName,
      serviceOrPackageTitle: serviceOrPackageTitle,
      price: price,
      dateTime: date,
      timeSlot: timeSlot,
      status: AppointmentStatus.scheduled,
      reminderEnabled: true,
      loyaltyPointsEarned: pointsEarned,
    );

    _appointments.insert(0, newAppointment);

    _userLoyaltyPoints += pointsEarned;
    _loyaltyTransactions.insert(
      0,
      LoyaltyTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Agendamento: $serviceOrPackageTitle',
        points: pointsEarned,
        date: DateTime.now(),
        isEarned: true,
      ),
    );

    notifyListeners();
  }

  void cancelAppointment(String appointmentId) {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(
        status: AppointmentStatus.cancelled,
      );
      notifyListeners();
    }
  }

  void toggleReminder(String appointmentId) {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      final current = _appointments[index].reminderEnabled;
      _appointments[index] = _appointments[index].copyWith(
        reminderEnabled: !current,
      );
      notifyListeners();
    }
  }

  // Redeem Reward
  bool redeemReward(LoyaltyReward reward) {
    if (_userLoyaltyPoints >= reward.pointsRequired) {
      _userLoyaltyPoints -= reward.pointsRequired;
      _loyaltyTransactions.insert(
        0,
        LoyaltyTransaction(
          id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Resgate: ${reward.title}',
          points: -reward.pointsRequired,
          date: DateTime.now(),
          isEarned: false,
        ),
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  // Management (CRUD) Methods
  void addService(ServiceItem service) {
    _services.add(service);
    notifyListeners();
  }

  void removeService(String serviceId) {
    _services.removeWhere((s) => s.id == serviceId);
    notifyListeners();
  }

  void addProfessional(Professional professional) {
    _professionals.add(professional);
    notifyListeners();
  }

  void removeProfessional(String professionalId) {
    _professionals.removeWhere((p) => p.id == professionalId);
    notifyListeners();
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  void addComboPackage(ComboPackage combo) {
    _packages.add(combo);
    notifyListeners();
  }

  void removeComboPackage(String packageId) {
    _packages.removeWhere((p) => p.id == packageId);
    notifyListeners();
  }

  void addBranch(Branch branch) {
    _branches.add(branch);
    notifyListeners();
  }

  // Seed Initial Data
  void _initInitialData() {
    _branches.addAll([
      Branch(
        id: 'b1',
        name: 'Estação Elite - Matriz Centro',
        address: 'Av. Paulista, 1500 - Bela Vista, São Paulo',
        phone: '(11) 98765-4321',
        isMain: true,
        openingHours: 'Seg - Sáb: 08:00 - 21:00',
        imageUrl: 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1',
        managerEmails: ['gerente.centro@estacaoelite.com'],
      ),
      Branch(
        id: 'b2',
        name: 'Estação Elite - Filial Shopping',
        address: 'Shopping Morumbi, Piso L3, Loja 304',
        phone: '(11) 97654-3210',
        isMain: false,
        openingHours: 'Seg - Dom: 10:00 - 22:00',
        imageUrl: 'https://images.unsplash.com/photo-1585747860715-2ba37e788b70',
        managerEmails: ['gerente.shopping@estacaoelite.com'],
      ),
      Branch(
        id: 'b3',
        name: 'Estação Elite - Filial Jardins',
        address: 'Rua Oscar Freire, 890 - Jardins',
        phone: '(11) 99123-8877',
        isMain: false,
        openingHours: 'Ter - Sáb: 09:00 - 20:00',
        imageUrl: 'https://images.unsplash.com/photo-1621605815971-fbc98d665033',
        managerEmails: [],
      ),
    ]);

    _selectedBranch = _branches.first;

    // Initial default user: Super Admin
    _currentUser = UserProfile(
      id: 'usr_super',
      name: 'elcortelini',
      email: superAdminEmail,
      photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      role: UserRole.superAdmin,
    );

    _services.addAll([
      ServiceItem(
        id: 's1',
        title: 'Corte Executive Elite',
        description: 'Corte moderno com lavagem especial, finalização com pomada premium e massagem capilar.',
        price: 75.0,
        durationMinutes: 45,
        category: 'Cabelo',
        iconName: 'content_cut',
      ),
      ServiceItem(
        id: 's2',
        title: 'Barba de Respeito com Toalha Quente',
        description: 'Modelagem de barba com navalha tradicional, toalha quente, óleo hidratante e balm calmante.',
        price: 60.0,
        durationMinutes: 40,
        category: 'Barba',
        iconName: 'face',
      ),
      ServiceItem(
        id: 's3',
        title: 'Visagismo & Consultoria de Estilo',
        description: 'Análise do formato do rosto, harmonização de barba e cabelo sob medida para seu perfil.',
        price: 110.0,
        durationMinutes: 60,
        category: 'Estética',
        iconName: 'psychology',
      ),
      ServiceItem(
        id: 's4',
        title: 'Tratamento Antiqueda & Fortalecimento',
        description: 'Terapia capilar com LED, aplicação de tônico revigorante e massagem no couro cabeludo.',
        price: 95.0,
        durationMinutes: 40,
        category: 'Tratamento',
        iconName: 'spa',
      ),
      ServiceItem(
        id: 's5',
        title: 'Pezinho & Acabamento Navalhado',
        description: 'Manutenção do contorno do cabelo e barba com precisão na navalha.',
        price: 35.0,
        durationMinutes: 20,
        category: 'Cabelo',
        iconName: 'brush',
      ),
    ]);

    _professionals.addAll([
      Professional(
        id: 'p1',
        name: 'Carlos "Barba" Silva',
        role: 'Master Barber & Visagista',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
        rating: 4.9,
        branchIds: ['b1', 'b3'],
        workingDays: [1, 2, 3, 4, 5, 6],
        availableTimeSlots: ['09:00', '10:00', '11:00', '14:00', '15:30', '17:00', '18:30'],
        bio: 'Mais de 12 anos de experiência em cortes clássicos, fade e visagismo masculino.',
      ),
      Professional(
        id: 'p2',
        name: 'Marcos "Fade" Santos',
        role: 'Especialista em Degradê',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
        rating: 4.8,
        branchIds: ['b1', 'b2'],
        workingDays: [1, 2, 3, 4, 5],
        availableTimeSlots: ['09:30', '10:30', '13:00', '15:00', '16:30', '19:00'],
        bio: 'Referência em cortes urbanos, freestyle e manutenção de barbas volumosas.',
      ),
      Professional(
        id: 'p3',
        name: 'Lucas Visagista',
        role: 'Consultor de Imagem Masculina',
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        rating: 5.0,
        branchIds: ['b2', 'b3'],
        workingDays: [2, 3, 4, 5, 6],
        availableTimeSlots: ['10:00', '11:30', '14:30', '16:00', '17:30', '19:30'],
        bio: 'Especializado em harmonização capilar e tratamento de couro cabeludo.',
      ),
    ]);

    _products.addAll([
      Product(
        id: 'pr1',
        name: 'Pomada Matte Estação Elite (100g)',
        description: 'Fixação forte e efeito fosco natural. Não engordura os fios e dura o dia todo.',
        price: 59.90,
        category: 'Pomadas',
        imageUrl: 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1',
        stockByBranch: {'b1': 25, 'b2': 18, 'b3': 12},
        loyaltyPointsBonus: 20,
      ),
      Product(
        id: 'pr2',
        name: 'Óleo Hidratante para Barba Premium (30ml)',
        description: 'Blend de óleos nobres com fragrância amadeirada. Deixa a barba macia e perfumada.',
        price: 49.90,
        category: 'Barba',
        imageUrl: 'https://images.unsplash.com/photo-1608248597260-6578616b0b8d',
        stockByBranch: {'b1': 30, 'b2': 15, 'b3': 20},
        loyaltyPointsBonus: 15,
      ),
      Product(
        id: 'pr3',
        name: 'Shampoo Fortificante Mentolado (250ml)',
        description: 'Limpeza profunda, sensação refrescante e estimulação do crescimento forte.',
        price: 45.00,
        category: 'Shampoos',
        imageUrl: 'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d',
        stockByBranch: {'b1': 40, 'b2': 30, 'b3': 25},
        loyaltyPointsBonus: 15,
      ),
    ]);

    _packages.addAll([
      ComboPackage(
        id: 'pkg1',
        title: 'Combo Elite Total (Corte + Barba + Pomada)',
        description: 'Corte Executive + Barba com Toalha Quente + Levando a Pomada Matte para casa.',
        originalPrice: 194.90,
        packagePrice: 159.90,
        serviceNames: ['Corte Executive Elite', 'Barba de Respeito'],
        productNames: ['Pomada Matte Estação Elite'],
        bonusPoints: 80,
        badgeText: 'MAIS POPULAR',
      ),
      ComboPackage(
        id: 'pkg2',
        title: 'Pacote Barba de Respeito + Óleo',
        description: 'Modelagem completa da barba na navalha + Frasco de Óleo Hidratante Premium.',
        originalPrice: 109.90,
        packagePrice: 89.90,
        serviceNames: ['Barba de Respeito com Toalha Quente'],
        productNames: ['Óleo Hidratante para Barba Premium'],
        bonusPoints: 50,
        badgeText: 'ECONOMIA DE R\$ 20',
      ),
      ComboPackage(
        id: 'pkg3',
        title: 'Dia do Noivo & Alinhamento VIP',
        description: 'Corte + Barba + Visagismo + Tratamento Capilar com brinde especial da casa.',
        originalPrice: 340.00,
        packagePrice: 279.00,
        serviceNames: ['Corte Executive', 'Barba', 'Visagismo', 'Tratamento'],
        productNames: ['Kit Completo de Cuidados'],
        bonusPoints: 150,
        badgeText: 'VIP & LUXO',
      ),
    ]);

    _appointments.addAll([
      Appointment(
        id: 'apt_demo_1',
        branchId: 'b1',
        branchName: 'Estação Elite - Matriz Centro',
        professionalId: 'p1',
        professionalName: 'Carlos "Barba" Silva',
        serviceOrPackageTitle: 'Combo Elite Total (Corte + Barba + Pomada)',
        price: 159.90,
        dateTime: DateTime.now().add(const Duration(days: 1)),
        timeSlot: '15:30',
        status: AppointmentStatus.scheduled,
        reminderEnabled: true,
        loyaltyPointsEarned: 80,
      ),
    ]);

    _loyaltyRewards.addAll([
      LoyaltyReward(
        id: 'r1',
        title: 'Pezinho & Acabamento Grátis',
        description: 'Manutenção rápida de contorno sem custo.',
        pointsRequired: 150,
        category: 'Serviço',
      ),
      LoyaltyReward(
        id: 'r2',
        title: 'Desconto de R\$ 30 no Corte Executive',
        description: 'Abata R\$ 30 no valor do seu próximo corte.',
        pointsRequired: 250,
        category: 'Desconto',
      ),
      LoyaltyReward(
        id: 'r3',
        title: 'Pomada Matte Estação Elite Grátis',
        description: 'Resgate um pote de 100g da nossa pomada oficial.',
        pointsRequired: 400,
        category: 'Produto',
      ),
      LoyaltyReward(
        id: 'r4',
        title: 'Corte + Barba Grátis (Combo VIP)',
        description: 'Serviço completo por conta da casa!',
        pointsRequired: 600,
        category: 'VIP',
      ),
    ]);

    _loyaltyTransactions.addAll([
      LoyaltyTransaction(
        id: 'tx_init_1',
        title: 'Bônus de Boas-Vindas Estação Elite',
        points: 100,
        date: DateTime.now().subtract(const Duration(days: 10)),
        isEarned: true,
      ),
      LoyaltyTransaction(
        id: 'tx_init_2',
        title: 'Agendamento: Corte Executive',
        points: 30,
        date: DateTime.now().subtract(const Duration(days: 5)),
        isEarned: true,
      ),
      LoyaltyTransaction(
        id: 'tx_init_3',
        title: 'Compra: Pomada Matte',
        points: 20,
        date: DateTime.now().subtract(const Duration(days: 2)),
        isEarned: true,
      ),
    ]);

    _promoBanners.addAll([
      PromoBanner(
        id: 'pb1',
        title: 'ESTAÇÃO ELITE BARBEARIA',
        subtitle: 'Estilo, precisão e experiência premium para o homem moderno.',
        badge: 'BEM-VINDO',
        actionRoute: '/booking',
        imageUrl: 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1',
      ),
      PromoBanner(
        id: 'pb2',
        title: 'O CLUBE DE FIDELIDADE',
        subtitle: 'Acumule pontos em cada visita e troque por serviços e produtos grátis.',
        badge: 'PONTOS ELITE',
        actionRoute: '/loyalty',
        imageUrl: 'https://images.unsplash.com/photo-1621605815971-fbc98d665033',
      ),
      PromoBanner(
        id: 'pb3',
        title: 'COMBOS PROMOCIONAIS',
        subtitle: 'Economize até R\$ 60 agrupando corte, barba e produtos exclusivos.',
        badge: 'OFERTA ESPECIAL',
        actionRoute: '/catalog',
        imageUrl: 'https://images.unsplash.com/photo-1585747860715-2ba37e788b70',
      ),
    ]);
  }
}

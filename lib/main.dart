import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'state/barbershop_provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/my_appointments_screen.dart';
import 'screens/loyalty_screen.dart';
import 'screens/admin_management_screen.dart';
import 'screens/super_admin_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  runApp(
    ChangeNotifierProvider(
      create: (_) => BarbershopProvider(),
      child: const EstacaoEliteApp(),
    ),
  );
}

class EstacaoEliteApp extends StatelessWidget {
  const EstacaoEliteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estação Elite Barbearia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigationWrapper(),
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarbershopProvider>(context);

    // Build pages dynamically based on user role
    final List<Widget> pages = [];
    final List<BottomNavigationBarItem> navItems = [];

    // Tab 0: Home (All roles)
    pages.add(HomeScreen(
      onNavigateTab: _navigateToTab,
      onStartBooking: () => _navigateToTab(2),
    ));
    navItems.add(const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Início',
    ));

    // Tab 1: Catalog (All roles)
    pages.add(CatalogScreen(
      onStartBooking: () => _navigateToTab(2),
    ));
    navItems.add(const BottomNavigationBarItem(
      icon: Icon(Icons.grid_view_outlined),
      activeIcon: Icon(Icons.grid_view),
      label: 'Catálogo',
    ));

    // Tab 2: Booking (All roles)
    pages.add(BookingScreen(
      onBookingComplete: () => _navigateToTab(3),
    ));
    navItems.add(const BottomNavigationBarItem(
      icon: Icon(Icons.calendar_month_outlined),
      activeIcon: Icon(Icons.calendar_month),
      label: 'Agendar',
    ));

    // Tab 3: Appointments (All roles)
    pages.add(MyAppointmentsScreen(
      onNewBooking: () => _navigateToTab(2),
    ));
    navItems.add(const BottomNavigationBarItem(
      icon: Icon(Icons.event_available_outlined),
      activeIcon: Icon(Icons.event_available),
      label: 'Agenda',
    ));

    // Tab 4: Role Specific (Fidelidade for Client, Gestão for Store Owner / Super Admin)
    if (provider.isClient) {
      pages.add(const LoyaltyScreen());
      navItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.stars_outlined),
        activeIcon: Icon(Icons.stars),
        label: 'Fidelidade',
      ));
    } else {
      pages.add(const AdminManagementScreen());
      navItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.storefront_outlined),
        activeIcon: Icon(Icons.storefront),
        label: 'Gestão Loja',
      ));
    }

    // Additional Tab for Super Admin: Portal Super Admin
    if (provider.isSuperAdmin) {
      pages.add(const SuperAdminScreen());
      navItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.shield_outlined),
        activeIcon: Icon(Icons.shield),
        label: 'Super Admin',
      ));
    }

    // Last Tab: Google Login & Profile Switcher (All roles)
    pages.add(LoginScreen(
      onLoginSuccess: () => _navigateToTab(0),
    ));
    navItems.add(const BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined),
      activeIcon: Icon(Icons.account_circle),
      label: 'Perfil/Login',
    ));

    // Ensure index doesn't go out of bounds when switching roles
    final safeIndex = _currentIndex >= pages.length ? 0 : _currentIndex;

    return Scaffold(
      body: IndexedStack(
        index: safeIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: safeIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: navItems,
      ),
    );
  }
}

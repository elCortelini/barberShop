import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:estacao_elite/main.dart';
import 'package:estacao_elite/state/barbershop_provider.dart';

void main() {
  testWidgets('Estacao Elite App smoke test for Super Admin and Client', (WidgetTester tester) async {
    await initializeDateFormatting('pt_BR', null);

    final provider = BarbershopProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const EstacaoEliteApp(),
      ),
    );

    // Initial user is Super Admin -> Dashboard is shown
    expect(find.text('Dashboard do Gerente'), findsWidgets);

    // Switch user to Client
    provider.loginWithGoogle(email: 'cliente.teste@gmail.com', name: 'Cliente Teste');
    await tester.pumpAndSettle();

    // Now Home Screen with ESTAÇÃO ELITE BARBEARIA is shown for Client
    expect(find.text('ESTAÇÃO ELITE BARBEARIA'), findsWidgets);
  });
}

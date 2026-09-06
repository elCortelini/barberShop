import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:estacao_elite/main.dart';
import 'package:estacao_elite/state/barbershop_provider.dart';

void main() {
  testWidgets('Estacao Elite App smoke test', (WidgetTester tester) async {
    await initializeDateFormatting('pt_BR', null);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => BarbershopProvider(),
        child: const EstacaoEliteApp(),
      ),
    );

    expect(find.text('ESTAÇÃO ELITE BARBEARIA'), findsWidgets);
  });
}

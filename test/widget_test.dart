import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carrinho_de_compras/app.dart';

void main() {
  testWidgets('App inicializa sem erros na tela de catálogo', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    // Aguarda apenas um frame — não usa pumpAndSettle para evitar
    // requisições de rede reais que podem travar o teste.
    await tester.pump();

    expect(find.text('Catálogo'), findsOneWidget);

    // Drena timers pendentes (ex: Future.delayed de 500ms do ProductsApi)
    // para que o framework não reclame de timers ativos após o teste.
    await tester.pump(const Duration(seconds: 1));
  });
}

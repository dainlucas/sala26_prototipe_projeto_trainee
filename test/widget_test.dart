import 'package:chave_26/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('mostra a identidade inicial do Chave 26', (testador) async {
    await testador.pumpWidget(const AplicativoChave26());

    expect(find.text('Chave 26'), findsOneWidget);
    expect(find.text('Sala 26'), findsOneWidget);
    expect(
      find.text('MVP local para acompanhar a chave da Prototipe'),
      findsOneWidget,
    );
  });

  testWidgets('mostra o mascote da Prototipe na tela inicial', (
    testador,
  ) async {
    await testador.pumpWidget(const AplicativoChave26());

    expect(find.bySemanticsLabel('Mascote da Prototipe'), findsOneWidget);
  });
}

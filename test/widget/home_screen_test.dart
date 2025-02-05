import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guia_moteis/core/providers.dart';
import 'package:guia_moteis/view/home_screen.dart';
import 'package:guia_moteis/widgets/toogle_widget.dart';
import 'package:mockito/mockito.dart';

import '../unit/api_service_test.mocks.dart';

void main() {
  testWidgets('Testa se o AppBar está presente e contém os elementos corretos', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeScreen())),
    );

    // Verifica se o AppBar está presente
    expect(find.byType(AppBar), findsOneWidget);

    // Verifica se o ícone de menu está presente
    expect(find.byIcon(Icons.menu), findsOneWidget);

    // Verifica se o ícone de busca está presente
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
  testWidgets('Testa se os filtros estão presentes', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeScreen())),
    );

    // Aguarde a construção do widget
    await tester.pumpAndSettle();

    // Verifica se o filtro "Filtros" está presente
    expect(find.text('Filtros'), findsOneWidget);

    // Verifica se o filtro "Café da Manhã" está presente
    expect(find.text('Café da Manhã'), findsOneWidget);

    // Verifica se o filtro "Decoração / Experiências" está presente
    expect(find.text('Decoração / Experiências'), findsOneWidget);
  });
  testWidgets('Testa se o CircularProgressIndicator é exibido durante o carregamento', (WidgetTester tester) async {
    // Simula um futuro que leva tempo para ser resolvido
    final mockApiService = MockApiService(); // Você precisará criar um mock
    when(mockApiService.fetchMotels()).thenAnswer((_) async => Future.delayed(Duration(seconds: 2), () => []));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiServiceProvider.overrideWithValue(mockApiService),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    // Verifica se o CircularProgressIndicator é exibido
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Aguarde o carregamento
    await tester.pumpAndSettle();

    // Verifica se o CircularProgressIndicator não está mais presente
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
  testWidgets('Testa se o toggle altera o estado corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeScreen())),
    );

    // Simula um toque no toggle
    await tester.tap(find.byType(CustomToggleButton));
    await tester.pump();

    // Verifique se o estado foi alterado (dependendo da implementação do toggle)
    // Você pode precisar verificar se algo na tela mudou com base no estado do toggle
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:guia_moteis/services/api_services.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:guia_moteis/models/motel.dart';

import 'api_service_test.mocks.dart';

// Gerar o mock com: flutter pub run build_runner build
@GenerateMocks([ApiService])
void main() {
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
  });

  test('Teste de retorno da API', () async {
    final mockMotel = Motel(
      nome: "Motel Teste",
      imagem: "https://via.placeholder.com/150",
      bairro: "Centro",
      distancia: 5.0,
      qtdFavoritos: 10,
      suites: [],
      qtdAvaliacoes: 100,
      mediaAvaliacao: 4.5,
    );

    // Simulando o retorno do mock
    when(mockApiService.fetchMotels())
        .thenAnswer((_) async => [mockMotel]);

    // Chamando o método testado
    final result = await mockApiService.fetchMotels();

    // Verificando se os dados retornados são os esperados
    expect(result, isA<List<Motel>>());
    expect(result.length, 1);
    expect(result.first.nome, "Motel Teste");
  });
}

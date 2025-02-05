import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guia_moteis/core/providers.dart';
import 'package:guia_moteis/models/motel.dart';
import 'package:mockito/mockito.dart';

class MockApiService extends Mock implements Motel {}

void main() {
  test('Testa se o provider retorna dados corretamente', () async {
    final container = ProviderContainer();
    final result = await container.read(motelsProvider.future);
    expect(result, isA<List<Motel>>());
  });
}

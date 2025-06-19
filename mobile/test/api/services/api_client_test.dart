import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/services/api_client.dart';

void main() {
  group('ApiClient', () {
    test('Inicialização', () {
      final client = ApiClient();
      expect(client, isNotNull);
    });
    // Adicione mais testes de métodos conforme sua implementação
  });
}

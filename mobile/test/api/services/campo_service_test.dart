import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/services/campo_service.dart';

void main() {
  group('CampoService', () {
    test('Inicialização', () {
      final service = CampoService(null);
      expect(service, isNotNull);
    });
    // Adicione mais testes de métodos conforme sua implementação
  });
}

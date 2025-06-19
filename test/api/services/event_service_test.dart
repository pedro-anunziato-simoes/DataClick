import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/services/event_service.dart';

void main() {
  group('EventService', () {
    test('Inicialização', () {
      final service = EventService(null);
      expect(service, isNotNull);
    });
    // Adicione mais testes de métodos conforme sua implementação
  });
}

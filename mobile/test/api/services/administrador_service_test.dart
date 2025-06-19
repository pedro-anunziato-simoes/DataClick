import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/services/administrador_service.dart';

void main() {
  group('AdministradorService', () {
    test('Inicialização', () {
      final service = AdministradorService(null);
      expect(service, isNotNull);
    });
    // Adicione mais testes de métodos conforme sua implementação
  });
}

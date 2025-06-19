import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/services/auth_service.dart';

void main() {
  group('AuthService', () {
    test('Inicialização', () {
      final service = AuthService();
      expect(service, isNotNull);
    });
    // Adicione mais testes de métodos conforme sua implementação
  });
}

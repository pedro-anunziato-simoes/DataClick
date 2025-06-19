import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/services/formulario_service.dart';

void main() {
  group('FormularioService', () {
    test('Inicialização', () {
      final service = FormularioService(null);
      expect(service, isNotNull);
    });
    // Adicione mais testes de métodos conforme sua implementação
  });
}

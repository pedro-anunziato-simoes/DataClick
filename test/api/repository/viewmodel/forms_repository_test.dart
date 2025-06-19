import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/repository/viewmodel/forms_repository.dart';

void main() {
  group('FormsRepository', () {
    test('Inicialização', () {
      final repo = FormsRepository();
      expect(repo, isNotNull);
    });
    // Adicione mais testes de métodos conforme sua implementação
  });
}

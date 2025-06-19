import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/repository/viewmodel/auth_viewmodel.dart';

void main() {
  group('AuthViewModel', () {
    test('Inicialização', () {
      final vm = AuthViewModel();
      expect(vm, isNotNull);
    });
    // Adicione mais testes de métodos e estados conforme sua implementação
  });
}

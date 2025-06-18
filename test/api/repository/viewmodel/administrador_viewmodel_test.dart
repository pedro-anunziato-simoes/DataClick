import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/repository/viewmodel/administrador_viewmodel.dart';

void main() {
  group('AdministradorViewModel', () {
    test('Inicialização', () {
      final vm = AdministradorViewModel();
      expect(vm, isNotNull);
    });
    // Adicione mais testes de métodos e estados conforme sua implementação
  });
}

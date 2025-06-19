import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/repository/viewmodel/forms_viewmodel.dart';

void main() {
  group('FormsViewModel', () {
    test('Inicialização', () {
      final vm = FormsViewModel();
      expect(vm, isNotNull);
    });
    // Adicione mais testes de métodos e estados conforme sua implementação
  });
}

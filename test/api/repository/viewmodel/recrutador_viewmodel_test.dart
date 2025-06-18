import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/repository/viewmodel/recrutador_viewmodel.dart';

void main() {
  group('RecrutadorViewModel', () {
    test('Inicialização', () {
      final vm = RecrutadorViewModel();
      expect(vm, isNotNull);
    });
    // Adicione mais testes de métodos e estados conforme sua implementação
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/repository/bloc/formulario_bloc.dart';

void main() {
  group('FormularioBloc', () {
    test('Inicialização', () {
      final bloc = FormularioBloc();
      expect(bloc, isNotNull);
    });
    // Adicione mais testes de eventos e estados conforme sua implementação
  });
}

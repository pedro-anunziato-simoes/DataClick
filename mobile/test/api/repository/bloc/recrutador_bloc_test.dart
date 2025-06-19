import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/repository/bloc/recrutador_bloc.dart';

void main() {
  group('RecrutadorBloc', () {
    test('Inicialização', () {
      final bloc = RecrutadorBloc();
      expect(bloc, isNotNull);
    });
    // Adicione mais testes de eventos e estados conforme sua implementação
  });
}

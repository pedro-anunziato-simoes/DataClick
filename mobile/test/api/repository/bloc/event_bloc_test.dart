import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/repository/bloc/event_bloc.dart';

void main() {
  group('EventBloc', () {
    test('Inicialização', () {
      final bloc = EventBloc();
      expect(bloc, isNotNull);
    });
    // Adicione mais testes de eventos e estados conforme sua implementação
  });
}

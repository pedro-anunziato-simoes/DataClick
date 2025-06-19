import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/repository/bloc/auth_bloc.dart';

void main() {
  group('AuthBloc', () {
    test('Inicialização', () {
      final bloc = AuthBloc();
      expect(bloc, isNotNull);
    });
    // Adicione mais testes de eventos e estados conforme sua implementação
  });
}

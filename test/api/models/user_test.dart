import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/models/user.dart';

void main() {
  group('User', () {
    test('Construtor e propriedades', () {
      final user = User(
        id: '1',
        nome: 'Teste',
        email: 'teste@email.com',
        telefone: '123',
        token: 'token',
      );
      expect(user.id, '1');
      expect(user.nome, 'Teste');
      expect(user.email, 'teste@email.com');
      expect(user.telefone, '123');
      expect(user.token, 'token');
    });

    test('fromJson e toJson', () {
      final json = {
        'id': '2',
        'nome': 'João',
        'email': 'joao@email.com',
        'telefone': '456',
        'token': 'tok2',
      };
      final user = User.fromJson(json);
      expect(user.id, '2');
      expect(user.nome, 'João');
      expect(user.email, 'joao@email.com');
      expect(user.telefone, '456');
      expect(user.token, 'tok2');
      expect(user.toJson()['nome'], 'João');
    });
  });
}

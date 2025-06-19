import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/models/recrutador.dart';

void main() {
  group('Recrutador', () {
    test('Construtor e propriedades', () {
      final rec = Recrutador(
        id: '1',
        nome: 'Maria',
        email: 'maria@email.com',
        telefone: '123',
        adminId: 'adm1',
        eventos: [],
      );
      expect(rec.id, '1');
      expect(rec.nome, 'Maria');
      expect(rec.email, 'maria@email.com');
      expect(rec.telefone, '123');
      expect(rec.adminId, 'adm1');
    });

    test('fromJson e toJson', () {
      final json = {
        'id': '2',
        'nome': 'João',
        'email': 'joao@email.com',
        'telefone': '456',
        'adminId': 'adm2',
        'eventos': [],
      };
      final rec = Recrutador.fromJson(json);
      expect(rec.id, '2');
      expect(rec.nome, 'João');
      expect(rec.email, 'joao@email.com');
      expect(rec.telefone, '456');
      expect(rec.adminId, 'adm2');
      expect(rec.toJson()['nome'], 'João');
    });
  });
}

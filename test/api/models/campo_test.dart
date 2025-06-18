import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/models/campo.dart';

void main() {
  group('Campo', () {
    test('Construtor e propriedades', () {
      final campo = Campo(
        campoId: '1',
        campoFormId: 'f1',
        titulo: 'Nome',
        tipo: 'TEXTO',
        resposta: 'João',
      );
      expect(campo.campoId, '1');
      expect(campo.campoFormId, 'f1');
      expect(campo.titulo, 'Nome');
      expect(campo.tipo, 'TEXTO');
      expect(campo.resposta, 'João');
    });

    test('fromJson e toJson', () {
      final json = {
        'campoId': '2',
        'campoFormId': 'f2',
        'titulo': 'Idade',
        'tipo': 'NUMERO',
        'resposta': 20,
      };
      final campo = Campo.fromJson(json);
      expect(campo.campoId, '2');
      expect(campo.titulo, 'Idade');
      expect(campo.tipo, 'NUMERO');
      expect(campo.resposta, 20);
      expect(campo.toJson()['titulo'], 'Idade');
    });
  });
}

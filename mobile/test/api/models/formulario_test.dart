import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/models/formulario.dart';
import 'package:mobile/api/models/campo.dart';

void main() {
  group('Formulario', () {
    test('Construtor e propriedades', () {
      final form = Formulario(
        id: '1',
        titulo: 'Ficha',
        adminId: 'adm1',
        campos: [],
        descricao: 'desc',
        dataCriacao: DateTime(2024, 6, 1),
        eventoId: 'ev1',
      );
      expect(form.id, '1');
      expect(form.titulo, 'Ficha');
      expect(form.adminId, 'adm1');
      expect(form.descricao, 'desc');
      expect(form.eventoId, 'ev1');
    });

    test('fromJson e toJson', () {
      final json = {
        'id': '2',
        'titulo': 'Formulário',
        'adminId': 'adm2',
        'campos': [
          {
            'campoId': 'c1',
            'titulo': 'Nome',
            'tipo': 'TEXTO',
            'resposta': 'João',
          },
        ],
        'descricao': 'desc2',
        'eventoId': 'ev2',
      };
      final form = Formulario.fromJson(json);
      expect(form.id, '2');
      expect(form.titulo, 'Formulário');
      expect(form.campos.first.titulo, 'Nome');
      expect(form.eventoId, 'ev2');
      expect(form.toJson()['titulo'], 'Formulário');
    });
  });
}

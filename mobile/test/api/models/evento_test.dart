import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/models/evento.dart';

void main() {
  group('Evento', () {
    test('Construtor e propriedades', () {
      final evento = Evento(
        eventoId: '1',
        eventoTitulo: 'Festa',
        dataInicio: DateTime(2025, 6, 18),
        dataFim: DateTime(2025, 6, 19),
        local: 'Salão',
        descricao: 'Aniversário',
        formulariosAssociados: [],
        recrutadoresEnvolvidos: [],
        administradoresEnvolvidos: [],
        status: 'ATIVO',
      );
      expect(evento.eventoId, '1');
      expect(evento.eventoTitulo, 'Festa');
      expect(evento.local, 'Salão');
      expect(evento.status, 'ATIVO');
    });

    test('fromJson e toJson', () {
      final json = {
        'eventoId': '2',
        'eventoTitulo': 'Palestra',
        'dataInicio': '2025-06-18T00:00:00.000',
        'dataFim': '2025-06-19T00:00:00.000',
        'local': 'Auditório',
        'descricao': 'Tech',
        'formulariosAssociados': [],
        'recrutadoresEnvolvidos': [],
        'administradoresEnvolvidos': [],
        'status': 'ATIVO',
      };
      final evento = Evento.fromJson(json);
      expect(evento.eventoId, '2');
      expect(evento.eventoTitulo, 'Palestra');
      expect(evento.local, 'Auditório');
      expect(evento.status, 'ATIVO');
      expect(evento.toJson()['eventoTitulo'], 'Palestra');
    });
  });
}

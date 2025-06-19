import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mobile/lib/api/services/event_service.dart';
import '../../mobile/lib/api/api_client.dart';
import '../../mobile/lib/api/models/evento.dart';

import 'campo_service_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient mockApiClient;
  late EventService eventService;

  final now = DateTime.now();
  final eventoModel = Evento(
    id: 'evento-123',
    nome: 'Evento de Teste',
    dataInicio: now,
    dataFim: now.add(const Duration(days: 1)),
    local: 'Local Teste',
    descricao: 'Descrição do evento',
    formulariosAssociados: [],
    recrutadoresEnvolvidos: [],
    administradoresEnvolvidos: [],
    status: 'ATIVO',
  );
  final eventoId = eventoModel.id;
  final eventoJson = json.encode(eventoModel.toJson());

  setUp(() {
    mockApiClient = MockApiClient();
    eventService = EventService(mockApiClient);
  });

  group('EventService Tests', () {
    test('obterEventoPorId com sucesso deve retornar Evento', () async {
      final endpoint = '/eventos/$eventoId';
      when(
        mockApiClient.get(endpoint),
      ).thenAnswer((_) async => http.Response(eventoJson, 200));

      final result = await eventService.obterEventoPorId(eventoId);

      expect(result, isA<Evento>());
      expect(result.id, eventoId);
      expect(result.nome, eventoModel.nome);
      verify(mockApiClient.get(endpoint)).called(1);
    });

    test(
      'obterEventoPorId com ID inexistente deve lançar ApiException',
      () async {
        final nonExistentId = 'evento-999';
        final endpoint = '/eventos/$nonExistentId';
        final errorJson = '{"message": "Evento não encontrado"}';
        when(
          mockApiClient.get(endpoint),
        ).thenAnswer((_) async => http.Response(errorJson, 404));

        expect(
          () async => await eventService.obterEventoPorId(nonExistentId),
          throwsA(isA<Exception>()),
        );
        verify(mockApiClient.get(endpoint)).called(1);
      },
    );

    test('criarEvento com sucesso deve retornar Evento criado', () async {
      final endpoint = '/eventos/criar';
      final newEventoData = Evento(
        id: '',
        nome: 'Novo Evento',
        dataInicio: now.add(const Duration(days: 2)),
        dataFim: now.add(const Duration(days: 3)),
        local: 'Novo Local',
        descricao: 'Descrição Nova',
        formulariosAssociados: [],
        recrutadoresEnvolvidos: [],
        administradoresEnvolvidos: [],
        status: 'PLANEJADO',
      );
      final requestBodyMap = newEventoData.toJson();
      final createdEventoModel = newEventoData.copyWith(id: 'evento-456');
      final createdEventoJson = json.encode(createdEventoModel.toJson());

      when(
        mockApiClient.post(
          endpoint,
          body: requestBodyMap,
        ),
      ).thenAnswer(
        (_) async => http.Response(createdEventoJson, 201),
      );

      final result = await eventService.criarEvento(newEventoData);

      expect(result, isA<Evento>());
      expect(result.id, 'evento-456');
      expect(result.nome, 'Novo Evento');
      verify(mockApiClient.post(endpoint, body: requestBodyMap)).called(1);
    });

    test('listarEventos com sucesso deve retornar List<Evento>', () async {
      final endpoint = '/eventos';
      final eventoList = [
        eventoModel,
        eventoModel.copyWith(id: 'evento-789', nome: 'Outro Evento'),
      ];
      final listJson = json.encode(eventoList.map((e) => e.toJson()).toList());

      when(
        mockApiClient.get(endpoint),
      ).thenAnswer((_) async => http.Response(listJson, 200));

      final result = await eventService.listarEventos();

      expect(result, isA<List<Evento>>());
      expect(result.length, 2);
      expect(result[0].id, eventoId);
      expect(result[1].nome, 'Outro Evento');
      verify(mockApiClient.get(endpoint)).called(1);
    });

    test('atualizarEvento com sucesso deve retornar Evento atualizado',
        () async {
      final endpoint = '/eventos/alterar/{eventoId}';
      final updatedEventoData = eventoModel.copyWith(
        nome: 'Evento Atualizado',
        status: 'CONCLUIDO',
      );
      final requestBodyMap = updatedEventoData.toJson();
      final updatedEventoJson = json.encode(
        updatedEventoData.toJson(),
      );

      when(
        mockApiClient.post(endpoint, body: requestBodyMap),
      ).thenAnswer((_) async => http.Response(updatedEventoJson, 200));

      final result = await eventService.atualizarEvento(
        eventoId,
        updatedEventoData,
      );

      expect(result, isA<Evento>());
      expect(result.id, eventoId);
      expect(result.nome, 'Evento Atualizado');
      expect(result.status, 'CONCLUIDO');
      verify(mockApiClient.post(endpoint, body: requestBodyMap)).called(1);
    });

    test(
      'removerEvento com sucesso não deve lançar exceção (status 200/204)',
      () async {
        final endpoint = '/eventos/remove/$eventoId';
        when(mockApiClient.delete(endpoint)).thenAnswer(
          (_) async => http.Response('', 204),
        );

        await expectLater(eventService.removerEvento(eventoId), completes);
        verify(mockApiClient.delete(endpoint)).called(1);
      },
    );

    test('removerEvento com falha deve lançar ApiException', () async {
      final endpoint = '/eventos/remove/$eventoId';
      final errorJson = '{"message": "Erro ao remover"}';
      when(
        mockApiClient.delete(endpoint),
      ).thenAnswer((_) async => http.Response(errorJson, 500));

      expect(
        () async => await eventService.removerEvento(eventoId),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.delete(endpoint)).called(1);
    });
  });
}

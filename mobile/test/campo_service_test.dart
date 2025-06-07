import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mobile/lib/api/services/campo_service.dart';
import '../../mobile/lib/api/api_client.dart';
import '../../mobile/lib/api/models/campo.dart';

import 'campo_service_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient mockApiClient;
  late CampoService campoService;

  final campoModel = Campo(
    campoId: 'campo-123',
    titulo: 'Nome Completo',
    tipo: 'texto',
    resposta: {},
  );
  final campoId = campoModel.campoId;
  final campoJson = json.encode(campoModel.toJson());
  final formularioId = 'form-abc';

  setUp(() {
    mockApiClient = MockApiClient();
    campoService = CampoService(mockApiClient);
  });

  group('CampoService Tests', () {
    test('getCampoById com sucesso deve retornar Campo', () async {
      final endpoint = '/campos/$campoId';
      when(
        mockApiClient.get(endpoint, includeAuth: true),
      ).thenAnswer((_) async => http.Response(campoJson, 200));

      final result = await campoService.getCampoById(campoId);

      expect(result, isA<Campo>());
      expect(result.campoId, campoId);
      verify(mockApiClient.get(endpoint, includeAuth: true)).called(1);
    });

    test('getCampoById com ID inexistente deve lançar Exception', () async {
      final nonExistentId = 'campo-999';
      final endpoint = '/campos/$nonExistentId';
      when(mockApiClient.get(endpoint, includeAuth: true)).thenAnswer(
        (_) async => http.Response('{"message": "Campo não encontrado"}', 404),
      );

      expect(
        () async => await campoService.getCampoById(nonExistentId),
        throwsA(
          isA<Exception>(),
        ),
      );
      verify(mockApiClient.get(endpoint, includeAuth: true)).called(1);
    });

    test('alterarCampo com sucesso deve retornar Campo atualizado', () async {
      final novoTitulo = 'Nome Completo Alterado';
      final novoTipo = 'email';
      final endpoint = '/campos/alterar/$campoId'; // Path used in service
      final requestBody = json.encode({
        'campoTipoDto': novoTipo,
        'campoTituloDto': novoTitulo,
      });
      final updatedCampoModel = campoModel.copyWith(
        titulo: novoTitulo,
        tipo: novoTipo,
      );
      final updatedCampoJson = json.encode(updatedCampoModel.toJson());

      when(
        mockApiClient.post(endpoint, body: requestBody, includeAuth: true),
      ).thenAnswer((_) async => http.Response(updatedCampoJson, 200));

      final result = await campoService.alterarCampo(
        campoId: campoId,
        tipo: novoTipo,
        titulo: novoTitulo,
      );

      expect(result, isA<Campo>());
      expect(result.campoId, campoId);
      expect(result.titulo, novoTitulo);
      expect(result.tipo, novoTipo);
      verify(
        mockApiClient.post(endpoint, body: requestBody, includeAuth: true),
      ).called(1);
    });

    test('alterarCampo com falha deve lançar Exception', () async {
      final endpoint = '/campos/alterar/$campoId';
      when(
        mockApiClient.post(endpoint, body: anyNamed('body'), includeAuth: true),
      ).thenAnswer(
        (_) async => http.Response('{"message": "Erro ao alterar"}', 500),
      );

      expect(
        () async => await campoService.alterarCampo(
          campoId: campoId,
          tipo: 't',
          titulo: 't',
        ),
        throwsA(isA<Exception>()),
      );
      verify(
        mockApiClient.post(endpoint, body: anyNamed('body'), includeAuth: true),
      ).called(1);
    });

    test(
      'deletarCampo com sucesso não deve lançar Exception (status 200)',
      () async {
        final endpoint = '/campos/remover/$campoId'; // Path used in service
        when(
          mockApiClient.delete(endpoint, includeAuth: true),
        ).thenAnswer((_) async => http.Response('', 200)); // Expect 200 OK

        await expectLater(campoService.deletarCampo(campoId), completes);
        verify(mockApiClient.delete(endpoint, includeAuth: true)).called(1);
      },
    );

    test('deletarCampo com falha deve lançar Exception', () async {
      final endpoint = '/campos/remover/$campoId';
      when(mockApiClient.delete(endpoint, includeAuth: true)).thenAnswer(
        (_) async => http.Response('{"message": "Erro ao remover"}', 500),
      );

      expect(
        () async => await campoService.deletarCampo(campoId),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.delete(endpoint, includeAuth: true)).called(1);
    });

    test('getCamposByFormId com sucesso deve retornar List<Campo>', () async {
      final campoList = [
        campoModel,
        campoModel.copyWith(campoId: 'campo-456', titulo: 'Email'),
      ];
      final listJson = json.encode(campoList.map((c) => c.toJson()).toList());
      final endpoint = '/campos/findByFormId/$formularioId';

      when(
        mockApiClient.get(endpoint, includeAuth: true),
      ).thenAnswer((_) async => http.Response(listJson, 200));

      final result = await campoService.getCamposByFormId(formularioId);

      expect(result, isA<List<Campo>>());
      expect(result.length, 2);
      expect(result[0].campoId, campoId);
      expect(result[1].titulo, 'Email');
      verify(mockApiClient.get(endpoint, includeAuth: true)).called(1);
    });

    test('getCamposByFormId com falha deve lançar Exception', () async {
      final endpoint = '/campos/findByFormId/$formularioId';
      when(mockApiClient.get(endpoint, includeAuth: true)).thenAnswer(
        (_) async =>
            http.Response('{"message": "Formulário não encontrado"}', 404),
      );

      expect(
        () async => await campoService.getCamposByFormId(formularioId),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.get(endpoint, includeAuth: true)).called(1);
    });

    test('adicionarCampo com sucesso deve retornar Campo', () async {
      final novoTitulo = 'Telefone';
      final novoTipo = 'telefone';
      final endpoint = '/campos/add/$formularioId';
      final requestBody = json.encode({
        'campoTituloDto': novoTitulo,
        'campoTipoDto': novoTipo,
      });
      final createdCampoModel = Campo(
        campoId: 'campo-789',
        titulo: novoTitulo,
        tipo: novoTipo,
        resposta: {},
      );
      final createdCampoJson = json.encode(createdCampoModel.toJson());

      when(
        mockApiClient.post(endpoint, body: requestBody, includeAuth: true),
      ).thenAnswer(
        (_) async => http.Response(createdCampoJson, 201),
      );

      final result = await campoService.adicionarCampo(
        formularioId,
        novoTitulo,
        novoTipo,
      );

      expect(result, isA<Campo>());
      expect(
        result.campoId,
        'campo-789',
      );
      expect(result.titulo, novoTitulo);
      expect(result.tipo, novoTipo);
      verify(
        mockApiClient.post(endpoint, body: requestBody, includeAuth: true),
      ).called(1);
    });

    test('adicionarCampo com falha deve lançar Exception', () async {
      final endpoint = '/campos/add/$formularioId';
      when(
        mockApiClient.post(endpoint, body: anyNamed('body'), includeAuth: true),
      ).thenAnswer(
        (_) async => http.Response('{"message": "Erro ao adicionar"}', 500),
      );

      expect(
        () async => await campoService.adicionarCampo(formularioId, 't', 't'),
        throwsA(isA<Exception>()),
      );
      verify(
        mockApiClient.post(endpoint, body: anyNamed('body'), includeAuth: true),
      ).called(1);
    });
  });
}

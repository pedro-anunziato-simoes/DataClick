import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../mobile/lib/api/services/formulario_service.dart';
import '../../mobile/lib/api/api_client.dart';
import '../../mobile/lib/api/models/formulario.dart';
import '../../mobile/lib/api/models/campo.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late FormularioService formularioService;

  final campoModel = Campo(
    campoId: 'campo-123',
    titulo: 'Nome Completo',
    tipo: 'texto',
    resposta: {},
  );

  final formularioModel = Formulario(
    id: 'form-456',
    titulo: 'Formulário de Teste',
    adminId: 'admin-789',
    eventoId: 'evento-abc',
    campos: [campoModel],
  );
  final formularioId = formularioModel.id;
  final eventoId = formularioModel.eventoId!;
  final formularioJson = json.encode(formularioModel.toJson());

  setUp(() {
    mockApiClient = MockApiClient();
    formularioService = FormularioService(mockApiClient);
  });

  group('FormularioService Tests', () {
    test('getFormularioById com sucesso deve retornar Formulario', () async {
      final endpoint = '/formularios/$formularioId';
      when(mockApiClient.get(endpoint, includeAuth: true))
          .thenAnswer((_) async => http.Response(formularioJson, 200));

      final result = await formularioService.getFormularioById(formularioId);

      expect(result, isA<Formulario>());
      expect(result.id, formularioId);
      expect(result.titulo, formularioModel.titulo);
      expect(result.campos.length, 1);
      expect(result.campos[0].campoId, campoModel.campoId);
      verify(mockApiClient.get(endpoint, includeAuth: true)).called(1);
    });

    test('getFormularioById com ID inexistente deve lançar ApiException',
        () async {
      final nonExistentId = 'form-999';
      final endpoint = '/formularios/$nonExistentId';
      final errorJson = '{"message": "Formulário não encontrado"}';
      when(mockApiClient.get(endpoint, includeAuth: true))
          .thenAnswer((_) async => http.Response(errorJson, 404));

      expect(
        () async => await formularioService.getFormularioById(nonExistentId),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.get(endpoint, includeAuth: true)).called(1);
    });

    test('criarFormulario com sucesso deve retornar Formulario criado',
        () async {
      final createEndpoint = '/formularios/add/$eventoId';
      final checkEventEndpoint = '/eventos/$eventoId';
      final novoFormulario = Formulario(
        id: '',
        titulo: 'Novo Formulário',
        adminId: 'admin-123',
        eventoId: eventoId,
        campos: [campoModel.copyWith(campoId: 'campo-new')],
      );
      final requestBodyMap = {
        'titulo': novoFormulario.titulo,
        'eventoId': novoFormulario.eventoId,
        'campos': novoFormulario.campos.map((c) => c.toJson()).toList(),
      };

      final createdFormularioModel = Formulario(
        id: 'form-new-123',
        titulo: novoFormulario.titulo,
        adminId: novoFormulario.adminId,
        eventoId: novoFormulario.eventoId,
        campos: novoFormulario.campos,
      );
      final createdFormularioJson =
          json.encode(createdFormularioModel.toJson());

      when(mockApiClient.get(checkEventEndpoint))
          .thenAnswer((_) async => http.Response('{}', 200));
      when(mockApiClient.post(
        createEndpoint,
        body: json.encode(requestBodyMap),
        includeAuth: true,
      )).thenAnswer((_) async => http.Response(createdFormularioJson, 201));

      final result = await formularioService.criarFormulario(
        titulo: novoFormulario.titulo,
        eventoId: novoFormulario.eventoId!,
        campos: novoFormulario.campos,
      );

      expect(result, isA<Formulario>());
      expect(result.id, 'form-new-123');
      expect(result.titulo, 'Novo Formulário');
      verify(mockApiClient.get(checkEventEndpoint)).called(1);
      verify(mockApiClient.post(createEndpoint,
              body: json.encode(requestBodyMap), includeAuth: true))
          .called(1);
    });

    test('getFormulariosByEvento com sucesso deve retornar List<Formulario>',
        () async {
      final endpoint = '/formularios/formulario/evento/$eventoId';
      final outroFormulario = Formulario(
          id: 'form-789',
          titulo: 'Outro Formulário',
          adminId: formularioModel.adminId,
          eventoId: formularioModel.eventoId,
          campos: formularioModel.campos);
      final formList = [formularioModel, outroFormulario];
      final listJson = json.encode(formList.map((f) => f.toJson()).toList());

      when(mockApiClient.get(endpoint, includeAuth: true))
          .thenAnswer((_) async => http.Response(listJson, 200));

      final result = await formularioService.getFormulariosByEvento(eventoId);

      expect(result, isA<List<Formulario>>());
      expect(result.length, 2);
      expect(result[0].id, formularioId);
      expect(result[1].titulo, 'Outro Formulário');
      verify(mockApiClient.get(endpoint, includeAuth: true)).called(1);
    });

    test('alterarFormulario com sucesso deve retornar Formulario atualizado',
        () async {
      final endpoint = '/formularios/alterar/$formularioId';
      final updatedFormularioData = formularioModel.copyWith(
        id: formularioId,
        titulo: 'Formulário Atualizado',
        adminId: formularioModel.adminId,
        eventoId: formularioModel.eventoId,
        campos: [campoModel.copyWith(titulo: 'Nome Completo Atualizado')],
      );
      final requestBodyMap = {
        'titulo': updatedFormularioData.titulo,
        'campos': updatedFormularioData.campos.map((c) => c.toJson()).toList(),
      };
      final updatedFormularioJson = json.encode(updatedFormularioData.toJson());
      when(mockApiClient.put(
        endpoint,
        body: json.encode(requestBodyMap),
        includeAuth: true,
      )).thenAnswer((_) async => http.Response(updatedFormularioJson, 200));

      final result = await formularioService.alterarFormulario(
        formId: formularioId,
        titulo: updatedFormularioData.titulo,
        campos: updatedFormularioData.campos,
      );

      expect(result, isA<Formulario>());
      expect(result.id, formularioId);
      expect(result.titulo, 'Formulário Atualizado');
      expect(result.campos[0].titulo, 'Nome Completo Atualizado');
      verify(mockApiClient.put(endpoint,
              body: json.encode(requestBodyMap), includeAuth: true))
          .called(1);
    });

    test(
        'removerFormulario com sucesso não deve lançar exceção (status 200/204)',
        () async {
      final endpoint = '/formularios/remove/$formularioId';
      when(mockApiClient.delete(endpoint, includeAuth: true))
          .thenAnswer((_) async => http.Response('', 204));

      await expectLater(
          formularioService.removerFormulario(formularioId), completes);
      verify(mockApiClient.delete(endpoint, includeAuth: true)).called(1);
    });

    test('removerFormulario com falha deve lançar ApiException', () async {
      final endpoint = '/formularios/remove/$formularioId';
      final errorJson = '{"message": "Erro ao remover"}';
      when(mockApiClient.delete(endpoint, includeAuth: true))
          .thenAnswer((_) async => http.Response(errorJson, 500));

      expect(
        () async => await formularioService.removerFormulario(formularioId),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.delete(endpoint, includeAuth: true)).called(1);
    });

    test('getFormulariosPreenchidos com sucesso deve retornar List<Formulario>',
        () async {
      final endpoint = '/formulariosPreenchidos/$eventoId';
      final preenchidoForm = Formulario(
          id: 'form-preenchido-1',
          titulo: formularioModel.titulo,
          adminId: formularioModel.adminId,
          eventoId: formularioModel.eventoId,
          campos: formularioModel.campos);
      final formList = [preenchidoForm];
      final listJson = json.encode(formList.map((f) => f.toJson()).toList());

      when(mockApiClient.get(endpoint, includeAuth: true))
          .thenAnswer((_) async => http.Response(listJson, 200));

      final result =
          await formularioService.getFormulariosPreenchidos(eventoId);

      expect(result, isA<List<Formulario>>());
      expect(result.length, 1);
      expect(result[0].id, 'form-preenchido-1');
      verify(mockApiClient.get(endpoint, includeAuth: true)).called(1);
    });
  });
}

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mobile/lib/api/services/campo_service.dart';
import '../../mobile/lib/api/api_client.dart';
import '../../mobile/lib/api/models/campo.dart';

// Importe o arquivo gerado pelo build_runner
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
    // Inicialize o mock corretamente usando o MockApiClient gerado
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
      // Arrange
      final nonExistentId = 'campo-999';
      final endpoint = '/campos/$nonExistentId';
      // Mock the ApiClient's get method to return non-200 status
      when(mockApiClient.get(endpoint, includeAuth: true)).thenAnswer(
        (_) async => http.Response('{"message": "Campo não encontrado"}', 404),
      );

      // Act & Assert
      expect(
        () async => await campoService.getCampoById(nonExistentId),
        throwsA(
          isA<Exception>(),
        ), // Expecting ApiException or generic Exception
      );
      verify(mockApiClient.get(endpoint, includeAuth: true)).called(1);
    });

    // --- Test: alterarCampo --- (Corresponds to service's alterarCampo)
    test('alterarCampo com sucesso deve retornar Campo atualizado', () async {
      // Arrange
      final novoTitulo = 'Nome Completo Alterado';
      final novoTipo = 'email';
      final endpoint = '/campos/alterar/$campoId'; // Path used in service
      // Expected request body based on service implementation
      final requestBody = json.encode({
        'campoTipoDto': novoTipo,
        'campoTituloDto': novoTitulo,
      });
      // Create the expected result model
      final updatedCampoModel = campoModel.copyWith(
        titulo: novoTitulo,
        tipo: novoTipo,
      );
      final updatedCampoJson = json.encode(updatedCampoModel.toJson());

      // Mock the ApiClient's post method (service uses POST for alterar)
      when(
        mockApiClient.post(endpoint, body: requestBody, includeAuth: true),
      ).thenAnswer((_) async => http.Response(updatedCampoJson, 200));

      // Act
      final result = await campoService.alterarCampo(
        campoId: campoId,
        tipo: novoTipo,
        titulo: novoTitulo,
      );

      // Assert
      expect(result, isA<Campo>());
      expect(result.campoId, campoId);
      expect(result.titulo, novoTitulo);
      expect(result.tipo, novoTipo);
      verify(
        mockApiClient.post(endpoint, body: requestBody, includeAuth: true),
      ).called(1);
    });

    test('alterarCampo com falha deve lançar Exception', () async {
      // Arrange
      final endpoint = '/campos/alterar/$campoId';
      // Mock the ApiClient's post method to return non-200 status
      when(
        mockApiClient.post(endpoint, body: anyNamed('body'), includeAuth: true),
      ).thenAnswer(
        (_) async => http.Response('{"message": "Erro ao alterar"}', 500),
      );

      // Act & Assert
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

    // --- Test: deletarCampo --- (Corresponds to service's deletarCampo)
    test(
      'deletarCampo com sucesso não deve lançar Exception (status 200)',
      () async {
        // Arrange
        final endpoint = '/campos/remover/$campoId'; // Path used in service
        // Mock the ApiClient's delete method
        when(
          mockApiClient.delete(endpoint, includeAuth: true),
        ).thenAnswer((_) async => http.Response('', 200)); // Expect 200 OK

        // Act & Assert
        await expectLater(campoService.deletarCampo(campoId), completes);
        verify(mockApiClient.delete(endpoint, includeAuth: true)).called(1);
      },
    );

    // Note: Service code only checks for != 200, so a 204 test isn't strictly necessary based on *that* code.
    // If the API *can* return 204, the service logic should be updated.

    test('deletarCampo com falha deve lançar Exception', () async {
      // Arrange
      final endpoint = '/campos/remover/$campoId';
      // Mock the ApiClient's delete method to return non-200 status
      when(mockApiClient.delete(endpoint, includeAuth: true)).thenAnswer(
        (_) async => http.Response('{"message": "Erro ao remover"}', 500),
      );

      // Act & Assert
      expect(
        () async => await campoService.deletarCampo(campoId),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.delete(endpoint, includeAuth: true)).called(1);
    });

    // --- Test: getCamposByFormId --- (Corresponds to service's getCamposByFormId)
    test('getCamposByFormId com sucesso deve retornar List<Campo>', () async {
      // Arrange
      final campoList = [
        campoModel,
        campoModel.copyWith(campoId: 'campo-456', titulo: 'Email'),
      ];
      final listJson = json.encode(campoList.map((c) => c.toJson()).toList());
      final endpoint =
          '/campos/findByFormId/$formularioId'; // Path used in service

      // Mock the ApiClient's get method
      when(
        mockApiClient.get(endpoint, includeAuth: true),
      ).thenAnswer((_) async => http.Response(listJson, 200));

      // Act
      final result = await campoService.getCamposByFormId(formularioId);

      // Assert
      expect(result, isA<List<Campo>>());
      expect(result.length, 2);
      expect(result[0].campoId, campoId);
      expect(result[1].titulo, 'Email');
      verify(mockApiClient.get(endpoint, includeAuth: true)).called(1);
    });

    test('getCamposByFormId com falha deve lançar Exception', () async {
      // Arrange
      final endpoint = '/campos/findByFormId/$formularioId';
      // Mock the ApiClient's get method to return non-200 status
      when(mockApiClient.get(endpoint, includeAuth: true)).thenAnswer(
        (_) async =>
            http.Response('{"message": "Formulário não encontrado"}', 404),
      );

      // Act & Assert
      expect(
        () async => await campoService.getCamposByFormId(formularioId),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.get(endpoint, includeAuth: true)).called(1);
    });

    // --- Test: adicionarCampo --- (Corresponds to service's adicionarCampo)
    test('adicionarCampo com sucesso deve retornar Campo', () async {
      // Arrange
      final novoTitulo = 'Telefone';
      final novoTipo = 'telefone';
      final endpoint = '/campos/add/$formularioId'; // Path used in service
      // Expected request body based on service implementation
      final requestBody = json.encode({
        'campoTituloDto': novoTitulo,
        'campoTipoDto': novoTipo,
      });
      // Create the expected result model (assuming API returns the created object)
      final createdCampoModel = Campo(
        campoId: 'campo-789',
        titulo: novoTitulo,
        tipo: novoTipo,
        resposta: {},
      );
      final createdCampoJson = json.encode(createdCampoModel.toJson());

      // Mock the ApiClient's post method
      when(
        mockApiClient.post(endpoint, body: requestBody, includeAuth: true),
      ).thenAnswer(
        (_) async => http.Response(createdCampoJson, 201),
      ); // Expect 201 Created

      // Act
      final result = await campoService.adicionarCampo(
        formularioId,
        novoTitulo,
        novoTipo,
      );

      // Assert
      expect(result, isA<Campo>());
      expect(
        result.campoId,
        'campo-789',
      ); // Check against the mocked response ID
      expect(result.titulo, novoTitulo);
      expect(result.tipo, novoTipo);
      verify(
        mockApiClient.post(endpoint, body: requestBody, includeAuth: true),
      ).called(1);
    });

    test('adicionarCampo com falha deve lançar Exception', () async {
      // Arrange
      final endpoint = '/campos/add/$formularioId';
      // Mock the ApiClient's post method to return non-200/201 status
      when(
        mockApiClient.post(endpoint, body: anyNamed('body'), includeAuth: true),
      ).thenAnswer(
        (_) async => http.Response('{"message": "Erro ao adicionar"}', 500),
      );

      // Act & Assert
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

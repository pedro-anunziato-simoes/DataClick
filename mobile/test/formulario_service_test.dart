import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http; // Keep for http.Response type
import 'package:mockito/mockito.dart';

// Adjust relative paths based on your actual project structure
// Assuming tests are in 'test/' and code is in 'lib/api/...'
import '../../mobile/lib/api/services/formulario_service.dart';
import '../../mobile/lib/api/api_client.dart';
import '../../mobile/lib/api/models/formulario.dart';
import '../../mobile/lib/api/models/campo.dart'; // Import Campo model

// Definição manual do mock (abordagem mais simples e direta)
class MockApiClient extends Mock implements ApiClient {}

void main() {
  // Mocks and service instances
  late MockApiClient mockApiClient;
  late FormularioService formularioService;

  // Test data setup
  final campoModel = Campo(
    campoId: 'campo-123',
    titulo: 'Nome Completo',
    tipo: 'texto',
    resposta: {},
  );

  // Ensure the base model has all required fields defined in your Formulario class
  final formularioModel = Formulario(
    id: 'form-456',
    titulo: 'Formulário de Teste',
    adminId: 'admin-789',
    eventoId: 'evento-abc',
    campos: [campoModel],
  );
  final formularioId = formularioModel.id;
  final eventoId = formularioModel.eventoId!;
  // Use the model's toJson for consistency in mocked responses
  final formularioJson = json.encode(formularioModel.toJson());

  setUp(() {
    // Inicializar o mock do ApiClient
    mockApiClient = MockApiClient();
    // Instantiate the service with the MOCKED ApiClient
    formularioService = FormularioService(mockApiClient);
  });

  group('FormularioService Tests', () {
    // --- Test: getFormularioById --- (Matches service method)
    test('getFormularioById com sucesso deve retornar Formulario', () async {
      // Arrange
      final endpoint = '/formularios/$formularioId'; // Path used in service
      // Mock the ApiClient's get method
      when(mockApiClient.get(endpoint, includeAuth: true))
          .thenAnswer((_) async => http.Response(formularioJson, 200));

      // Act
      final result = await formularioService.getFormularioById(formularioId);

      // Assert
      expect(result, isA<Formulario>());
      expect(result.id, formularioId);
      expect(result.titulo, formularioModel.titulo);
      expect(result.campos.length, 1);
      expect(result.campos[0].campoId, campoModel.campoId);
      verify(mockApiClient.get(endpoint, includeAuth: true)).called(1);
    });

    test('getFormularioById com ID inexistente deve lançar ApiException',
        () async {
      // Arrange
      final nonExistentId = 'form-999';
      final endpoint = '/formularios/$nonExistentId';
      final errorJson = '{"message": "Formulário não encontrado"}';
      // Mock the ApiClient's get method to return non-200 status
      when(mockApiClient.get(endpoint, includeAuth: true))
          .thenAnswer((_) async => http.Response(errorJson, 404));

      // Act & Assert
      expect(
        () async => await formularioService.getFormularioById(nonExistentId),
        throwsA(isA<Exception>()), // Service throws ApiException
      );
      verify(mockApiClient.get(endpoint, includeAuth: true)).called(1);
    });

    // --- Test: criarFormulario --- (Matches service method)
    test('criarFormulario com sucesso deve retornar Formulario criado',
        () async {
      // Arrange
      final createEndpoint =
          '/formularios/add/$eventoId'; // Path used in service
      final checkEventEndpoint =
          '/eventos/$eventoId'; // Path checked in service
      // Data for the new form - Ensure all required fields are present
      final novoFormulario = Formulario(
        id: '', // ID ignored by backend, but provide empty string if required by constructor
        titulo: 'Novo Formulário', // Required
        adminId: 'admin-123', // Required
        eventoId: eventoId, // Required by service logic
        campos: [campoModel.copyWith(campoId: 'campo-new')], // Required
      );
      final requestBodyMap = {
        'titulo': novoFormulario.titulo,
        'eventoId': novoFormulario.eventoId,
        'campos': novoFormulario.campos.map((c) => c.toJson()).toList(),
      };
      // Mocked response (assuming API returns the created form with an ID)
      // Ensure this also has all required fields
      final createdFormularioModel = Formulario(
        id: 'form-new-123', // ID returned by API
        titulo: novoFormulario.titulo,
        adminId: novoFormulario.adminId,
        eventoId: novoFormulario.eventoId,
        campos: novoFormulario.campos,
      );
      final createdFormularioJson =
          json.encode(createdFormularioModel.toJson());

      // Mock the check for event existence
      when(mockApiClient.get(checkEventEndpoint)).thenAnswer(
          (_) async => http.Response('{}', 200)); // Assume event exists
      // Mock the ApiClient's post method for creation
      when(mockApiClient.post(
        createEndpoint,
        body: json.encode(requestBodyMap), // Service encodes the map
        includeAuth: true,
      )).thenAnswer((_) async =>
          http.Response(createdFormularioJson, 201)); // Expect 201 Created

      // Act
      final result = await formularioService.criarFormulario(
        titulo: novoFormulario.titulo,
        eventoId: novoFormulario.eventoId!,
        campos: novoFormulario.campos,
      );

      // Assert
      expect(result, isA<Formulario>());
      expect(result.id, 'form-new-123'); // Check against the mocked response ID
      expect(result.titulo, 'Novo Formulário');
      verify(mockApiClient.get(checkEventEndpoint)).called(1);
      verify(mockApiClient.post(createEndpoint,
              body: json.encode(requestBodyMap), includeAuth: true))
          .called(1);
    });

    // --- Test: getFormulariosByEvento --- (Matches service method)
    test('getFormulariosByEvento com sucesso deve retornar List<Formulario>',
        () async {
      // Arrange
      final endpoint =
          '/formularios/formulario/evento/$eventoId'; // Path used in service
      // Ensure copyWith provides all required fields
      final outroFormulario = Formulario(
          id: 'form-789',
          titulo: 'Outro Formulário',
          adminId: formularioModel.adminId,
          eventoId: formularioModel.eventoId,
          campos: formularioModel.campos);
      final formList = [formularioModel, outroFormulario];
      final listJson = json.encode(formList.map((f) => f.toJson()).toList());

      // Mock the ApiClient's get method
      when(mockApiClient.get(endpoint, includeAuth: true))
          .thenAnswer((_) async => http.Response(listJson, 200));

      // Act
      final result = await formularioService.getFormulariosByEvento(eventoId);

      // Assert
      expect(result, isA<List<Formulario>>());
      expect(result.length, 2);
      expect(result[0].id, formularioId);
      expect(result[1].titulo, 'Outro Formulário');
      verify(mockApiClient.get(endpoint, includeAuth: true)).called(1);
    });

    // --- Test: alterarFormulario --- (Matches service method)
    test('alterarFormulario com sucesso deve retornar Formulario atualizado',
        () async {
      // Arrange
      final endpoint =
          '/formularios/alterar/$formularioId'; // Path used in service
      // Ensure copyWith provides all required fields
      final updatedFormularioData = formularioModel.copyWith(
        id: formularioId, // Explicitly pass ID if copyWith requires it
        titulo: 'Formulário Atualizado', // Provide new title
        adminId: formularioModel.adminId, // Keep original adminId
        eventoId: formularioModel.eventoId, // Keep original eventoId
        campos: [
          campoModel.copyWith(titulo: 'Nome Completo Atualizado')
        ], // Update campos
      );
      final requestBodyMap = {
        'titulo': updatedFormularioData.titulo,
        'campos': updatedFormularioData.campos.map((c) => c.toJson()).toList(),
      };
      final updatedFormularioJson = json.encode(
          updatedFormularioData.toJson()); // API returns the updated object

      // Mock the ApiClient's put method (service uses PUT for update)
      when(mockApiClient.put(
        endpoint,
        body: json.encode(requestBodyMap), // Service encodes the map
        includeAuth: true,
      )).thenAnswer((_) async => http.Response(updatedFormularioJson, 200));

      // Act
      final result = await formularioService.alterarFormulario(
        formId: formularioId,
        titulo: updatedFormularioData.titulo,
        campos: updatedFormularioData.campos,
      );

      // Assert
      expect(result, isA<Formulario>());
      expect(result.id, formularioId);
      expect(result.titulo, 'Formulário Atualizado');
      expect(result.campos[0].titulo, 'Nome Completo Atualizado');
      verify(mockApiClient.put(endpoint,
              body: json.encode(requestBodyMap), includeAuth: true))
          .called(1);
    });

    // --- Test: removerFormulario --- (Matches service method)
    test(
        'removerFormulario com sucesso não deve lançar exceção (status 200/204)',
        () async {
      // Arrange
      final endpoint =
          '/formularios/remove/$formularioId'; // Path used in service
      // Mock the ApiClient's delete method
      when(mockApiClient.delete(endpoint, includeAuth: true)).thenAnswer(
          (_) async => http.Response('', 204)); // Expect 204 No Content

      // Act & Assert
      await expectLater(
          formularioService.removerFormulario(formularioId), completes);
      verify(mockApiClient.delete(endpoint, includeAuth: true)).called(1);
    });

    test('removerFormulario com falha deve lançar ApiException', () async {
      // Arrange
      final endpoint = '/formularios/remove/$formularioId';
      final errorJson = '{"message": "Erro ao remover"}';
      // Mock the ApiClient's delete method to return non-200/204 status
      when(mockApiClient.delete(endpoint, includeAuth: true))
          .thenAnswer((_) async => http.Response(errorJson, 500));

      // Act & Assert
      expect(
        () async => await formularioService.removerFormulario(formularioId),
        throwsA(isA<Exception>()), // Service throws ApiException
      );
      verify(mockApiClient.delete(endpoint, includeAuth: true)).called(1);
    });

    // --- Test: getFormulariosPreenchidos --- (Matches service method)
    test('getFormulariosPreenchidos com sucesso deve retornar List<Formulario>',
        () async {
      // Arrange
      final endpoint =
          '/formulariosPreenchidos/$eventoId'; // Path used in service
      // Ensure copyWith provides all required fields
      final preenchidoForm = Formulario(
          id: 'form-preenchido-1',
          titulo: formularioModel.titulo, // Required
          adminId: formularioModel.adminId, // Required
          eventoId: formularioModel.eventoId, // Required
          campos: formularioModel.campos // Required
          );
      final formList = [preenchidoForm];
      final listJson = json.encode(formList.map((f) => f.toJson()).toList());

      // Mock the ApiClient's get method
      when(mockApiClient.get(endpoint, includeAuth: true))
          .thenAnswer((_) async => http.Response(listJson, 200));

      // Act
      final result =
          await formularioService.getFormulariosPreenchidos(eventoId);

      // Assert
      expect(result, isA<List<Formulario>>());
      expect(result.length, 1);
      expect(result[0].id, 'form-preenchido-1');
      verify(mockApiClient.get(endpoint, includeAuth: true)).called(1);
    });
  });
}

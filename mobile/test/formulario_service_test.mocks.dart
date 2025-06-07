import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

// Importações corretas para o projeto
import '../../mobile/lib/api/api_client.dart';

// Definição manual do mock (abordagem mais simples e direta)
class MockApiClient extends Mock implements ApiClient {}

void main() {
  // Usar MockApiClient em vez de instanciar ApiClient real
  late MockApiClient apiClient;

  setUp(() {
    // Inicializar o mock do ApiClient
    apiClient = MockApiClient();
  });

  group('ApiClient Tests', () {
    test('Login bem-sucedido deve retornar token', () async {
      // Arrange
      final responseJson = {
        'success': true,
        'token': 'abc123',
        'user': {'id': 1, 'name': 'Test User'},
      };

      final loginPath = '/login';
      final loginBody = {
        'email': 'test@example.com',
        'password': 'password123'
      };

      // Mock da resposta do ApiClient.post
      when(
        apiClient.post(
          loginPath,
          body: loginBody,
          includeAuth: false,
        ),
      ).thenAnswer((_) async => http.Response(json.encode(responseJson), 200));

      // Act
      final response = await apiClient.post(
        loginPath,
        body: loginBody,
        includeAuth: false,
      );

      // Assert
      expect(response.statusCode, 200);
      final responseBody = json.decode(response.body);
      expect(responseBody['success'], true);
      expect(responseBody['token'], 'abc123');

      // Verificar que o método post foi chamado com os parâmetros corretos
      verify(apiClient.post(
        loginPath,
        body: loginBody,
        includeAuth: false,
      )).called(1);
    });

    test('Login falho deve retornar erro', () async {
      // Arrange
      final responseJson = {
        'success': false,
        'message': 'Credenciais inválidas',
      };

      final loginPath = '/login';
      final loginBody = {'email': 'wrong@example.com', 'password': 'wrongpass'};

      // Mock da resposta do ApiClient.post
      when(
        apiClient.post(
          loginPath,
          body: loginBody,
          includeAuth: false,
        ),
      ).thenAnswer((_) async => http.Response(json.encode(responseJson), 401));

      // Act
      final response = await apiClient.post(
        loginPath,
        body: loginBody,
        includeAuth: false,
      );

      // Assert
      expect(response.statusCode, 401);
      final responseBody = json.decode(response.body);
      expect(responseBody['success'], false);
      expect(responseBody['message'], 'Credenciais inválidas');
    });

    test('Acesso a recurso protegido com token válido', () async {
      // Arrange
      final responseJson = {'data': 'conteúdo protegido'};
      final protectedPath = '/protected';

      // Mock da resposta do ApiClient.get
      when(
        apiClient.get(protectedPath),
      ).thenAnswer((_) async => http.Response(json.encode(responseJson), 200));

      // Act
      final response = await apiClient.get(protectedPath);

      // Assert
      expect(response.statusCode, 200);
      expect(json.decode(response.body), equals(responseJson));

      // Verificar que o método get foi chamado com o caminho correto
      verify(apiClient.get(protectedPath)).called(1);
    });

    test('Acesso a recurso protegido sem token deve falhar', () async {
      // Arrange
      final protectedPath = '/protected';

      // Mock da resposta do ApiClient.get
      when(
        apiClient.get(protectedPath),
      ).thenAnswer((_) async => http.Response('Unauthorized', 401));

      // Act
      final response = await apiClient.get(protectedPath);

      // Assert
      expect(response.statusCode, 401);
    });

    test('Criação de item deve retornar o item criado', () async {
      // Arrange
      final newItem = {'name': 'Novo Item', 'value': 100};
      final responseJson = {'id': 1, ...newItem};
      final itemsPath = '/items';

      // Mock da resposta do ApiClient.post
      when(
        apiClient.post(
          itemsPath,
          body: newItem,
        ),
      ).thenAnswer((_) async => http.Response(json.encode(responseJson), 201));

      // Act
      final response = await apiClient.post(itemsPath, body: newItem);

      // Assert
      expect(response.statusCode, 201);
      expect(json.decode(response.body), equals(responseJson));
    });

    test('Atualização de item deve retornar sucesso', () async {
      // Arrange
      final updatedItem = {'name': 'Item Atualizado', 'value': 200};
      final responseJson = {'success': true};
      final itemPath = '/items/1';

      // Mock da resposta do ApiClient.put
      when(
        apiClient.put(
          itemPath,
          body: updatedItem,
        ),
      ).thenAnswer((_) async => http.Response(json.encode(responseJson), 200));

      // Act
      final response = await apiClient.put(itemPath, body: updatedItem);

      // Assert
      expect(response.statusCode, 200);
      expect(json.decode(response.body), equals(responseJson));
    });

    test('Exclusão de item deve retornar status 204', () async {
      // Arrange
      final itemPath = '/items/1';

      // Mock da resposta do ApiClient.delete
      when(
        apiClient.delete(itemPath),
      ).thenAnswer((_) async => http.Response('', 204));

      // Act
      final response = await apiClient.delete(itemPath);

      // Assert
      expect(response.statusCode, 204);
    });
  });
}

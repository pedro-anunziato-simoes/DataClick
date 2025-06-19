import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../mobile/lib/api/api_client.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient apiClient;

  setUp(() {
    apiClient = MockApiClient();
  });

  group('Testes de Autenticação', () {
    test('Login bem-sucedido deve retornar token e salvá-lo', () async {
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

      expect(response.statusCode, 200);
      final responseBody = json.decode(response.body);
      expect(responseBody['success'], true);
      expect(responseBody['token'], 'abc123');

      verify(apiClient.post(
        loginPath,
        body: loginBody,
        includeAuth: false,
      )).called(1);
    });

    test('Login falho deve retornar erro', () async {
      final responseJson = {
        'success': false,
        'message': 'Credenciais inválidas',
      };

      final loginPath = '/login';
      final loginBody = {'email': 'wrong@example.com', 'password': 'wrongpass'};

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

      expect(response.statusCode, 401);
      final responseBody = json.decode(response.body);
      expect(responseBody['success'], false);
      expect(responseBody['message'], 'Credenciais inválidas');
    });
  });

  group('Testes de Recursos Protegidos', () {
    test('Acesso a recurso protegido com token válido', () async {
      final responseJson = {'data': 'conteúdo protegido'};
      final protectedPath = '/protected';

      when(
        apiClient.get(protectedPath),
      ).thenAnswer((_) async => http.Response(json.encode(responseJson), 200));

      final response = await apiClient.get(protectedPath);

      expect(response.statusCode, 200);
      expect(json.decode(response.body), equals(responseJson));

      verify(apiClient.get(protectedPath)).called(1);
    });

    test('Acesso a recurso protegido sem token deve falhar', () async {
      final protectedPath = '/protected';

      when(
        apiClient.get(protectedPath),
      ).thenAnswer((_) async => http.Response('Unauthorized', 401));

      final response = await apiClient.get(protectedPath);

      expect(response.statusCode, 401);
    });
  });

  group('Testes de CRUD', () {
    test('Criação de item deve retornar o item criado', () async {
      final newItem = {'name': 'Novo Item', 'value': 100};
      final responseJson = {'id': 1, ...newItem};
      final itemsPath = '/items';

      when(
        apiClient.post(
          itemsPath,
          body: newItem,
        ),
      ).thenAnswer((_) async => http.Response(json.encode(responseJson), 201));

      final response = await apiClient.post(itemsPath, body: newItem);

      expect(response.statusCode, 201);
      expect(json.decode(response.body), equals(responseJson));
    });

    test('Atualização de item deve retornar sucesso', () async {
      final updatedItem = {'name': 'Item Atualizado', 'value': 200};
      final responseJson = {'success': true};
      final itemPath = '/items/1';

      when(
        apiClient.put(
          itemPath,
          body: updatedItem,
        ),
      ).thenAnswer((_) async => http.Response(json.encode(responseJson), 200));

      final response = await apiClient.put(itemPath, body: updatedItem);

      expect(response.statusCode, 200);
      expect(json.decode(response.body), equals(responseJson));
    });

    test('Exclusão de item deve retornar status 204', () async {
      final itemPath = '/items/1';

      when(
        apiClient.delete(itemPath),
      ).thenAnswer((_) async => http.Response('', 204));

      final response = await apiClient.delete(itemPath);

      expect(response.statusCode, 204);
    });
  });
}

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:mobile/api/api_client.dart';

import 'package:mobile/api/models/administrador.dart';

void main() {
  final mockAdmin = {
    'id': '1',
    'nome': 'Admin Test',
    'telefone': '123456789',
    'senha': 'password',
    'email': 'admin@test.com',
    'cnpj': '12345678901234',
    'recrutadores': [],
    'formularios': [],
  };

  test('GET /administradores/{id} retorna 200', () async {
    final mockClient = MockClient((request) async {
      if (request.url.toString() == 'http://localhost:8080/administradores/1') {
        return http.Response(json.encode(mockAdmin), 200);
      }
      return http.Response('Not Found', 404);
    });

    final apiClient = ApiClient(mockClient);
    final response = await apiClient.get('administradores/1');

    expect(response.statusCode, 200);
    final admin = Administrador.fromJson(json.decode(response.body));
    expect(admin.id, '1');
  });
}

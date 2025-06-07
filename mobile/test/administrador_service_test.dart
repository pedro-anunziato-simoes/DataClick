import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart' show GenerateMocks;
import 'package:mockito/mockito.dart';

import '../../mobile/lib/api/services/administrador_service.dart';
import '../../mobile/lib/api/api_client.dart';
import '../../mobile/lib/api/models/administrador.dart';
import '../../mobile/lib/api/endpoints.dart';
import 'campo_service_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient mockApiClient;
  late AdministradorService administradorService;

  final adminModel = Administrador(
    usuarioId: 'admin-123',
    nome: 'Admin Teste',
    telefone: '11999998888',
    email: 'admin.teste@example.com',
    token: 'fake-jwt-token',
    recrutadores: [],
    formularios: [],
    eventos: [],
  );
  final adminId = adminModel.usuarioId;
  final adminJson = json.encode(adminModel.toJson());

  setUp(() {
    mockApiClient = MockApiClient();

    administradorService = AdministradorService(mockApiClient);
  });

  group('AdministradorService Tests', () {
    test('obterPorId com sucesso deve retornar Administrador', () async {
      final endpoint = '${Endpoints.administradores}/$adminId';

      when(mockApiClient.get(endpoint))
          .thenAnswer((_) async => http.Response(adminJson, 200));

      final result = await administradorService.obterPorId(adminId);

      expect(result, isA<Administrador>());
      expect(result.usuarioId, adminId);
      expect(result.nome, adminModel.nome);
      expect(result.token, adminModel.token);
      verify(mockApiClient.get(endpoint)).called(1);
    });

    test('obterPorId com ID inexistente deve lançar Exception', () async {
      final nonExistentId = 'admin-999';
      final endpoint = '${Endpoints.administradores}/$nonExistentId';
      final errorJson = '{"message": "Administrador não encontrado"}';
      when(mockApiClient.get(endpoint))
          .thenAnswer((_) async => http.Response(errorJson, 404));

      expect(
        () async => await administradorService.obterPorId(nonExistentId),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.get(endpoint)).called(1);
    });

    test('criarAdministrador com sucesso deve retornar Administrador criado',
        () async {
      final endpoint = Endpoints.administradores;
      final newAdminData = Administrador(
        usuarioId: '',
        nome: 'Novo Admin',
        telefone: '11777776666',
        email: 'novo.admin@example.com',
        senha: 'password123',
      );
      final requestBody = json.encode(newAdminData.toJson());
      final createdAdminModel =
          newAdminData.copyWith(usuarioId: 'admin-456', token: 'new-token');
      final createdAdminJson = json.encode(createdAdminModel.toJson());

      when(mockApiClient.post(
        endpoint,
        body: requestBody,
      )).thenAnswer((_) async => http.Response(createdAdminJson, 201));

      final result =
          await administradorService.criarAdministrador(newAdminData);

      expect(result, isA<Administrador>());
      expect(result.usuarioId, 'admin-456');
      expect(result.nome, 'Novo Admin');
      expect(result.token, 'new-token');
      verify(mockApiClient.post(endpoint, body: requestBody)).called(1);
    });

    test(
        'removerAdministrador com sucesso não deve lançar exceção (status 200/204)',
        () async {
      final endpoint = Endpoints.removerAdministrador(adminId);
      when(mockApiClient.delete(endpoint))
          .thenAnswer((_) async => http.Response('', 204));
      await expectLater(
          administradorService.removerAdministrador(adminId), completes);
      verify(mockApiClient.delete(endpoint)).called(1);
    });

    test('removerAdministrador com falha deve lançar Exception', () async {
      final endpoint = Endpoints.removerAdministrador(adminId);
      final errorJson = '{"message": "Erro ao remover"}';

      when(mockApiClient.delete(endpoint))
          .thenAnswer((_) async => http.Response(errorJson, 500));

      expect(
        () async => await administradorService.removerAdministrador(adminId),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.delete(endpoint)).called(1);
    });
  });
}

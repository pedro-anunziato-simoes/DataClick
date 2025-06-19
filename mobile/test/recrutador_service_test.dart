import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import '../../mobile/lib/api/services/recrutador_service.dart';
import '../../mobile/lib/api/api_client.dart';
import '../../mobile/lib/api/models/recrutador.dart';
import '../../mobile/lib/api/services/api_exception.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late RecrutadorService recrutadorService;

  setUp(() {
    mockApiClient = MockApiClient();
    recrutadorService = RecrutadorService(mockApiClient);
  });

  group('RecrutadorService Tests', () {
    test('Listar recrutadores com sucesso', () async {
      final recrutadoresJson = [
        {
          'usuarioId': 'rec-123',
          'adminId': 'admin-456',
          'nome': 'Recrutador Teste 1',
          'telefone': '11999999999',
          'email': 'recrutador1@example.com',
          'senha': 'senha123'
        },
        {
          'usuarioId': 'rec-456',
          'adminId': 'admin-456',
          'nome': 'Recrutador Teste 2',
          'telefone': '11988888888',
          'email': 'recrutador2@example.com',
          'senha': 'senha456'
        }
      ];

      when(mockApiClient.get(
        '/recrutadores/list',
        includeAuth: true,
      )).thenAnswer(
          (_) async => http.Response(json.encode(recrutadoresJson), 200));

      final recrutadores = await recrutadorService.getRecrutadores();

      expect(recrutadores, isA<List<Recrutador>>());
      expect(recrutadores.length, 2);
      expect(recrutadores[0].usuarioId, 'rec-123');
      expect(recrutadores[0].nome, 'Recrutador Teste 1');
      expect(recrutadores[1].usuarioId, 'rec-456');
      verify(mockApiClient.get('/recrutadores/list', includeAuth: true))
          .called(1);
    });

    test('Buscar recrutador por ID com sucesso', () async {
      final recrutadorId = 'rec-123';
      final recrutadorJson = {
        'usuarioId': recrutadorId,
        'adminId': 'admin-456',
        'nome': 'Recrutador Teste',
        'telefone': '11999999999',
        'email': 'recrutador@example.com',
        'senha': 'senha123'
      };

      when(mockApiClient.get(
        '/recrutadores/$recrutadorId',
        includeAuth: true,
      )).thenAnswer(
          (_) async => http.Response(json.encode(recrutadorJson), 200));

      final recrutador =
          await recrutadorService.getRecrutadorById(recrutadorId);

      expect(recrutador, isA<Recrutador>());
      expect(recrutador.usuarioId, recrutadorId);
      expect(recrutador.nome, 'Recrutador Teste');
      verify(mockApiClient.get('/recrutadores/$recrutadorId',
              includeAuth: true))
          .called(1);
    });

    test('Buscar recrutador por email com sucesso', () async {
      final email = 'recrutador@example.com';
      final recrutadorJson = {
        'usuarioId': 'rec-123',
        'adminId': 'admin-456',
        'nome': 'Recrutador Teste',
        'telefone': '11999999999',
        'email': email,
        'senha': 'senha123'
      };

      when(mockApiClient.get(
        '/recrutadores/por-email/$email',
        includeAuth: true,
      )).thenAnswer(
          (_) async => http.Response(json.encode(recrutadorJson), 200));

      final recrutador = await recrutadorService.getRecrutadorByEmail(email);

      expect(recrutador, isA<Recrutador>());
      expect(recrutador.email, email);
      expect(recrutador.nome, 'Recrutador Teste');
      verify(mockApiClient.get('/recrutadores/por-email/$email',
              includeAuth: true))
          .called(1);
    });

    test('Buscar recrutador inexistente deve lançar ApiException', () async {
      final recrutadorId = 'rec-999';
      when(mockApiClient.get(
        '/recrutadores/$recrutadorId',
        includeAuth: true,
      )).thenAnswer((_) async => http.Response(
          json.encode({'message': 'Recrutador não encontrado'}), 404));

      expect(
          () async => await recrutadorService.getRecrutadorById(recrutadorId),
          throwsA(isA<ApiException>()));
      verify(mockApiClient.get('/recrutadores/$recrutadorId',
              includeAuth: true))
          .called(1);
    });

    test('Criar novo recrutador com sucesso', () async {
      final nome = 'Novo Recrutador';
      final email = 'novo@recrutador.com';
      final telefone = '11977777777';
      final senha = 'senha789';
      final adminId = 'admin-456';

      final recrutadorCreateDTO = RecrutadorCreateDTO(
          nome: nome,
          telefone: telefone,
          email: email,
          senha: senha,
          adminId: '');

      final requestBody = {
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'senha': senha,
        'adminId': adminId,
      };

      final recrutadorResponseJson = {
        'usuarioId': 'rec-789',
        'adminId': adminId,
        'nome': nome,
        'telefone': telefone,
        'email': email,
        'senha': senha
      };

      when(mockApiClient.post(
        '/recrutadores',
        body: json.encode(requestBody),
        includeAuth: true,
      )).thenAnswer(
          (_) async => http.Response(json.encode(recrutadorResponseJson), 201));

      final recrutador = await recrutadorService.criarRecrutador(
        recrutadorCreateDTO,
        nome: nome,
        email: email,
        telefone: telefone,
        senha: senha,
        adminId: adminId,
      );

      expect(recrutador, isA<Recrutador>());
      expect(recrutador.usuarioId, 'rec-789');
      expect(recrutador.nome, nome);
      expect(recrutador.email, email);
      verify(mockApiClient.post(
        '/recrutadores',
        body: json.encode(requestBody),
        includeAuth: true,
      )).called(1);
    });

    test('Alterar recrutador com sucesso', () async {
      final recrutadorId = 'rec-123';
      final nome = 'Recrutador Atualizado';
      final telefone = '11966666666';
      final email = 'atualizado@example.com';

      final requestBody = {
        'nome': nome,
        'telefone': telefone,
        'email': email,
      };

      final recrutadorResponseJson = {
        'usuarioId': recrutadorId,
        'adminId': 'admin-456',
        'nome': nome,
        'telefone': telefone,
        'email': email,
        'senha': 'senha123'
      };

      when(mockApiClient.post(
        '/recrutadores/alterar/$recrutadorId',
        body: json.encode(requestBody),
        includeAuth: true,
      )).thenAnswer(
          (_) async => http.Response(json.encode(recrutadorResponseJson), 200));

      final recrutador = await recrutadorService.alterarRecrutador(
        recrutadorId: recrutadorId,
        nome: nome,
        telefone: telefone,
        email: email,
      );

      expect(recrutador, isA<Recrutador>());
      expect(recrutador.usuarioId, recrutadorId);
      expect(recrutador.nome, nome);
      expect(recrutador.telefone, telefone);
      expect(recrutador.email, email);
      verify(mockApiClient.post(
        '/recrutadores/alterar/$recrutadorId',
        body: json.encode(requestBody),
        includeAuth: true,
      )).called(1);
    });

    test('Excluir recrutador com sucesso', () async {
      final recrutadorId = 'rec-123';
      when(mockApiClient.delete(
        '/recrutadores/remover/$recrutadorId',
        includeAuth: true,
      )).thenAnswer((_) async => http.Response('', 200));

      await recrutadorService.excluirRecrutador(recrutadorId);

      verify(mockApiClient.delete(
        '/recrutadores/remover/$recrutadorId',
        includeAuth: true,
      )).called(1);
    });

    test('Alterar email do recrutador com sucesso', () async {
      final recrutadorId = 'rec-123';
      final novoEmail = 'novo.email@example.com';
      final requestBody = {'email': novoEmail, 'recrutadorId': recrutadorId};

      when(mockApiClient.post(
        '/recrutadores/alterar/email',
        body: json.encode(requestBody),
        includeAuth: true,
      )).thenAnswer((_) async => http.Response('', 200));

      await recrutadorService.alterarEmail(novoEmail, recrutadorId);

      verify(mockApiClient.post(
        '/recrutadores/alterar/email',
        body: json.encode(requestBody),
        includeAuth: true,
      )).called(1);
    });

    test('Alterar senha do recrutador com sucesso', () async {
      final recrutadorId = 'rec-123';
      final novaSenha = 'novaSenha456';
      final requestBody = {'senha': novaSenha, 'recrutadorId': recrutadorId};

      when(mockApiClient.post(
        '/recrutadores/alterar/senha',
        body: json.encode(requestBody),
        includeAuth: true,
      )).thenAnswer((_) async => http.Response('', 200));

      await recrutadorService.alterarSenha(novaSenha, recrutadorId);

      verify(mockApiClient.post(
        '/recrutadores/alterar/senha',
        body: json.encode(requestBody),
        includeAuth: true,
      )).called(1);
    });

    test('Login com sucesso', () async {
      final email = 'recrutador@example.com';
      final senha = 'senha123';
      final requestBody = {'email': email, 'senha': senha};
      final responseJson = {'token': 'jwt-token-123'};

      when(mockApiClient.post(
        '/auth/login',
        body: json.encode(requestBody),
        includeAuth: false,
      )).thenAnswer((_) async => http.Response(json.encode(responseJson), 200));

      final token = await recrutadorService.login(email, senha);

      expect(token, 'jwt-token-123');
      verify(mockApiClient.post(
        '/auth/login',
        body: json.encode(requestBody),
        includeAuth: false,
      )).called(1);
    });
  });
}

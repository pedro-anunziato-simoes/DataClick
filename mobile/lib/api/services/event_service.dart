import 'dart:convert';
import 'package:mobile/api/api_client.dart';
import 'package:mobile/api/models/evento.dart';

import 'package:mobile/api/services/api_exception.dart';

class EventService {
  final ApiClient _apiClient;

  EventService(this._apiClient);

  String _getErrorMessage(String? responseBody) {
    if (responseBody == null || responseBody.isEmpty) {
      return 'Resposta vazia do servidor.';
    }
    try {
      final decoded = json.decode(responseBody);
      return decoded['message'] ??
          decoded['error'] ??
          decoded['details'] ??
          'Erro desconhecido ao processar a solicitação.';
    } catch (e) {
      return responseBody;
    }
  }

  static const String _eventosBasePath = '/eventos';

  Future<List<Evento>> listarEventos() async {
    try {
      final response = await _apiClient.get('$_eventosBasePath');
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData
            .map((data) => Evento.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          _getErrorMessage(response.body),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Falha ao carregar eventos: ${e.toString()}', 0);
    }
  }

  Future<Evento> obterEventoPorId(String id) async {
    try {
      final response = await _apiClient.get('$_eventosBasePath/$id');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return Evento.fromJson(responseData);
      } else {
        throw ApiException(
          _getErrorMessage(response.body),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Falha ao obter evento: ${e.toString()}', 0);
    }
  }

  Future<Evento> criarEvento(Evento evento) async {
    try {
      final response = await _apiClient.post(
        '$_eventosBasePath/criar',
        body: evento.toJson(),
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return Evento.fromJson(responseData);
      } else {
        throw ApiException(
          _getErrorMessage(response.body),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Falha ao criar evento: ${e.toString()}', 0);
    }
  }

  Future<Evento> atualizarEvento(String id, Evento evento) async {
    try {
      final response = await _apiClient.post(
        '$_eventosBasePath/alterar/{eventoId}',
        body: evento.toJson(),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return Evento.fromJson(responseData);
      } else {
        throw ApiException(
          _getErrorMessage(response.body),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Falha ao atualizar evento: ${e.toString()}', 0);
    }
  }

  Future<void> removerEvento(String id) async {
    try {
      final response = await _apiClient.delete('$_eventosBasePath/remove/$id');
      if (response.statusCode == 204 || response.statusCode == 200) {
        return;
      } else {
        throw ApiException(
          _getErrorMessage(response.body),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Falha ao remover evento: ${e.toString()}', 0);
    }
  }
}

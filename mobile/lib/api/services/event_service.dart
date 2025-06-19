import 'dart:convert';
import 'package:mobile/api/api_client.dart';
import 'package:mobile/api/models/evento.dart';
import 'package:mobile/api/services/api_exception.dart';

class EventService {
  final ApiClient _apiClient;
  static Evento? _eventoAtual;
  static String? _eventoIdAtual;

  EventService(this._apiClient);

  Evento? get eventoAtual => _eventoAtual;
  String? get eventoIdAtual => _eventoIdAtual;

  void setEventoAtual(Evento evento) {
    _eventoAtual = evento;
    _eventoIdAtual = evento.eventoId;
  }

  void setEventoIdAtual(String eventoId) {
    _eventoIdAtual = eventoId;
    if (_eventoAtual?.eventoId != eventoId) {
      _eventoAtual = null;
    }
  }

  void clearEventoAtual() {
    _eventoAtual = null;
    _eventoIdAtual = null;
  }

  bool get hasEventoAtual => _eventoIdAtual != null;

  String _getErrorMessage(String? responseBody, [int? statusCode]) {
    if (responseBody == null || responseBody.isEmpty) {
      return _getDefaultErrorMessage(statusCode);
    }

    try {
      final decoded = json.decode(responseBody);
      return decoded['message'] ??
          decoded['error'] ??
          decoded['details'] ??
          decoded['error_description'] ??
          _getDefaultErrorMessage(statusCode);
    } catch (e) {
      return responseBody.isNotEmpty
          ? responseBody
          : _getDefaultErrorMessage(statusCode);
    }
  }

  String _getDefaultErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Requisição inválida. Verifique os dados enviados.';
      case 401:
        return 'Não autorizado. Faça login novamente.';
      case 403:
        return 'Acesso negado. Permissões insuficientes.';
      case 404:
        return 'Evento não encontrado.';
      case 409:
        return 'Conflito. Evento já existe ou há conflito de dados.';
      case 422:
        return 'Dados inválidos. Verifique as informações fornecidas.';
      case 500:
        return 'Erro interno do servidor. Tente novamente mais tarde.';
      case 503:
        return 'Serviço temporariamente indisponível.';
      default:
        return 'Erro desconhecido ao processar a solicitação.';
    }
  }

  static const String _eventosBasePath = '/eventos';

  Future<List<Evento>> listarEventos() async {
    try {
      final response = await _apiClient.get(
        _eventosBasePath,
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData
            .map((data) => Evento.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          _getErrorMessage(response.body, response.statusCode),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Falha ao carregar eventos: ${e.toString()}', 0);
    }
  }

  Future<Evento> obterEventoPorId(
    String eventoId, {
    bool setAsAtual = true,
  }) async {
    try {
      final response = await _apiClient.get(
        '$_eventosBasePath/$eventoId',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final evento = Evento.fromJson(responseData);

        if (setAsAtual) {
          setEventoAtual(evento);
        }

        return evento;
      } else {
        throw ApiException(
          _getErrorMessage(response.body, response.statusCode),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Falha ao obter evento: ${e.toString()}', 0);
    }
  }

  Future<Evento?> obterEventoAtual() async {
    if (_eventoAtual != null) {
      return _eventoAtual;
    }

    if (_eventoIdAtual != null) {
      try {
        return await obterEventoPorId(_eventoIdAtual!, setAsAtual: true);
      } catch (e) {
        clearEventoAtual();
        return null;
      }
    }

    return null;
  }

  Future<Evento> criarEvento(Evento evento) async {
    try {
      final body = {
        'eventoTituloDto': evento.eventoTitulo,
        'eventoDescricaoDto': evento.descricao,
        'eventoDataDto': evento.dataInicio.toIso8601String(),
      };
      final response = await _apiClient.post(
        '$_eventosBasePath/criar',
        body: json.encode(body),
        includeAuth: true,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final novoEvento = Evento.fromJson(responseData);

        setEventoAtual(novoEvento);

        return novoEvento;
      } else {
        throw ApiException(
          _getErrorMessage(response.body, response.statusCode),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Falha ao criar evento: ${e.toString()}', 0);
    }
  }

  Future<Evento> atualizarEvento(String eventoId, Evento evento) async {
    try {
      final response = await _apiClient.put(
        '$_eventosBasePath/alterar/$eventoId',
        body: json.encode(evento.toJson()),
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final eventoAtualizado = Evento.fromJson(responseData);

        if (_eventoIdAtual == eventoId) {
          setEventoAtual(eventoAtualizado);
        }

        return eventoAtualizado;
      } else {
        throw ApiException(
          _getErrorMessage(response.body, response.statusCode),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Falha ao atualizar evento: ${e.toString()}', 0);
    }
  }

  Future<void> removerEvento(String eventoId) async {
    try {
      final response = await _apiClient.delete(
        '$_eventosBasePath/remove/$eventoId',
        includeAuth: true,
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        if (_eventoIdAtual == eventoId) {
          clearEventoAtual();
        }
        return;
      } else {
        throw ApiException(
          _getErrorMessage(response.body, response.statusCode),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Falha ao remover evento: ${e.toString()}', 0);
    }
  }

  Future<List<Evento>> buscarEventos({
    String? nome,
    String? status,
    DateTime? dataInicio,
    DateTime? dataFim,
    String? local,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (nome != null && nome.isNotEmpty) queryParams['nome'] = nome;
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (dataInicio != null)
        queryParams['dataInicio'] = dataInicio.toIso8601String();
      if (dataFim != null) queryParams['dataFim'] = dataFim.toIso8601String();
      if (local != null && local.isNotEmpty) queryParams['local'] = local;

      final uri = Uri.parse(
        _eventosBasePath,
      ).replace(queryParameters: queryParams);
      final response = await _apiClient.get(uri.toString(), includeAuth: true);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData
            .map((data) => Evento.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          _getErrorMessage(response.body, response.statusCode),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Falha ao buscar eventos: ${e.toString()}', 0);
    }
  }

  Future<bool> eventoExiste(String id) async {
    try {
      await obterEventoPorId(id, setAsAtual: false);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Evento>> listarMeusEventos() async {
    try {
      final response = await _apiClient.get(
        '$_eventosBasePath/meus',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData
            .map((data) => Evento.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          _getErrorMessage(response.body, response.statusCode),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Falha ao carregar meus eventos: ${e.toString()}', 0);
    }
  }
}

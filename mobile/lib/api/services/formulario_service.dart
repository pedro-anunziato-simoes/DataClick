import 'dart:convert';
import '../api_client.dart';
import '../models/formulario.dart';
import '../models/campo.dart';
import '../endpoints.dart';

class FormularioService {
  final ApiClient _apiClient;

  FormularioService(this._apiClient);

  Future<List<Formulario>> listarTodosFormularios() async {
    try {
      final response = await _apiClient.get(Endpoints.formularios);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          return data.map((json) => Formulario.fromJson(json)).toList();
        } else if (data['result'] is List) {
          return (data['result'] as List)
              .map((json) => Formulario.fromJson(json))
              .toList();
        }
        throw Exception('Formato de resposta inesperado');
      }

      throw Exception('Falha ao carregar formulários: ${response.statusCode}');
    } catch (e) {
      print('Erro ao listar formulários: $e');
      rethrow;
    }
  }

  Future<List<Formulario>> listarFormulariosPorAdmin(String adminId) async {
    try {
      final response = await _apiClient.get(
        Endpoints.formulariosPorAdmin(adminId),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          return data.map((json) => Formulario.fromJson(json)).toList();
        } else if (data['result'] is List) {
          return (data['result'] as List)
              .map((json) => Formulario.fromJson(json))
              .toList();
        }
        throw Exception('Formato de resposta inesperado');
      }

      // Fallback para dados locais se necessário
      return await _listarFormulariosLocalBackup(adminId);
    } catch (e) {
      print('Erro ao listar formulários do admin: $e');
      return await _listarFormulariosLocalBackup(adminId);
    }
  }

  Future<Formulario> criarFormulario(
    String adminId,
    String titulo,
    List<Campo> campos,
  ) async {
    try {
      final body = {
        "titulo": titulo,
        "adminId": adminId,
        "campos": campos.map((campo) => campo.toJson()).toList(),
      };

      final response = await _apiClient.post(
        Endpoints.adicionarFormulario(adminId),
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Formulario.fromJson(json.decode(response.body));
      }

      throw Exception('Falha ao criar formulário: ${response.statusCode}');
    } catch (e) {
      print('Erro ao criar formulário: $e');
      rethrow;
    }
  }

  Future<Formulario> atualizarFormulario(Formulario formulario) async {
    try {
      final response = await _apiClient.put(
        Endpoints.formularioPorId(formulario.id),
        body: formulario.toJson(),
      );

      if (response.statusCode == 200) {
        return Formulario.fromJson(json.decode(response.body));
      }

      throw Exception('Falha ao atualizar formulário: ${response.statusCode}');
    } catch (e) {
      print('Erro ao atualizar formulário: $e');
      rethrow;
    }
  }

  Future<Formulario> obterFormularioPorId(String id) async {
    try {
      final response = await _apiClient.get(Endpoints.formularioPorId(id));

      if (response.statusCode == 200) {
        return Formulario.fromJson(json.decode(response.body));
      }

      throw Exception('Falha ao obter formulário: ${response.statusCode}');
    } catch (e) {
      print('Erro ao obter formulário: $e');
      rethrow;
    }
  }

  Future<void> removerFormulario(String id) async {
    try {
      final response = await _apiClient.delete(Endpoints.removerFormulario(id));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao remover formulário: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao remover formulário: $e');
      rethrow;
    }
  }

  Future<List<Formulario>> _listarFormulariosLocalBackup(String adminId) async {
    return [];
  }
}

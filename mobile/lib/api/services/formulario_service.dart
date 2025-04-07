import 'dart:convert';
import '../api_client.dart';
import '../models/formulario.dart';
import '../models/campo.dart';
import '../endpoints.dart';

class FormularioService {
  final ApiClient _apiClient;

  FormularioService(this._apiClient);

  // Método para buscar todos os formulários (versão simplificada)
  Future<void> fetchFormularios() async {
    try {
      final response = await _apiClient.get(Endpoints.formularios);
      if (response.statusCode == 200) {
        print(response.body);
        // Processar dados aqui
      } else {
        print('Erro ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    }
  }

  // Método para buscar formulários que retorna uma lista tipada
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
      // Em caso de falha, tente usar o backup local
      return listarFormulariosLocalBackup(adminId);
    } catch (e) {
      // Em caso de exceção, use o backup local
      return listarFormulariosLocalBackup(adminId);
    }
  }

  Future<List<Formulario>> listarTodosFormularios() async {
    try {
      final response = await _apiClient.get(Endpoints.formularios);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.map((json) => Formulario.fromJson(json)).toList();
        }
        throw Exception('Formato de resposta inesperado');
      }
      throw Exception('Falha ao carregar formulários: ${response.statusCode}');
    } catch (e) {
      throw Exception('Erro ao listar formulários: ${e.toString()}');
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
      } else {
        throw Exception('Falha ao criar formulário: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao criar formulário: ${e.toString()}');
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
      throw Exception('Erro ao obter formulário: ${e.toString()}');
    }
  }

  Future<void> removerFormulario(String id) async {
    try {
      final response = await _apiClient.delete(Endpoints.removerFormulario(id));
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao remover formulário: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao remover formulário: ${e.toString()}');
    }
  }

  Future<List<Formulario>> listarFormulariosLocalBackup(String adminId) async {
    // Simulação de dados locais, substitua por uma implementação real
    return [];
  }
}

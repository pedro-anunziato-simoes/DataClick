import 'dart:convert';
import '../api_client.dart';
import '../models/formulario.dart';
import '../models/campo.dart';
import '../endpoints.dart';

class FormularioService {
  final ApiClient _apiClient;

  FormularioService(this._apiClient);

  Future<List<Formulario>> listarFormularios() async {
    try {
      final response = await _apiClient.get(Endpoints.formularios);
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Formulario.fromJson(json)).toList();
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
      final response = await _apiClient.post(
        Endpoints.adicionarFormulario(adminId),
        body: json.encode({
          'titulo': titulo,
          'campos': campos.map((e) => e.toJson()).toList(),
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        return Formulario.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Falha ao criar formulário: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao criar formulário: ${e.toString()}');
    }
  }

  Future<Formulario> obterFormularioPorId(String id) async {
    try {
      final response = await _apiClient.get(Endpoints.formularioPorId(id));
      return Formulario.fromJson(json.decode(response.body));
    } catch (e) {
      throw Exception('Erro ao obter formulário: ${e.toString()}');
    }
  }

  Future<List<Formulario>> formulariosPorAdministrador(String adminId) async {
    try {
      final response = await _apiClient.get(
        Endpoints.formulariosPorAdmin(adminId),
      );
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Formulario.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao listar formulários por admin: ${e.toString()}');
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
}

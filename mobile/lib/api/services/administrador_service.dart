import 'dart:convert';
import '../api_client.dart';
import '../endpoints.dart';
import '../models/administrador.dart';

class AdministradorService {
  final ApiClient _apiClient;

  AdministradorService(this._apiClient);

  Future<Administrador> criarAdministrador(Administrador administrador) async {
    final response = await _apiClient.post(
      Endpoints.administradores,
      body: json.encode(administrador.toJson()),
    );

    if (response.statusCode == 201) {
      return Administrador.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao criar administrador: ${response.statusCode}');
    }
  }

  Future<Administrador> obterPorId(String id) async {
    final response = await _apiClient.get('${Endpoints.administradores}/$id');

    if (response.statusCode == 200) {
      return Administrador.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao obter administrador: ${response.statusCode}');
    }
  }

  Future<void> removerAdministrador(String id) async {
    final response = await _apiClient.delete(
      Endpoints.removerAdministrador(id),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Falha ao remover administrador: ${response.statusCode}');
    }
  }

  listarAdministradores() {}

  atualizarAdministrador(Administrador updatedAdmin) {}

  alterarSenha(String s, String t) {}

  login(String s, String t) {}
}

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
      body: administrador.toJson(),
    );
    return Administrador.fromJson(json.decode(response.body));
  }

  Future<Administrador> obterPorId(String id) async {
    final response = await _apiClient.get('${Endpoints.administradores}/$id');
    return Administrador.fromJson(json.decode(response.body));
  }
}

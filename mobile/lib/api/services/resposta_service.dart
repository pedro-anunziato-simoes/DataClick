import 'dart:convert';
import '../api_client.dart';
import '../endpoints.dart';
import '../models/resposta.dart';

class RespostaService {
  final ApiClient _apiClient;

  RespostaService(this._apiClient);

  Future<Resposta> criarResposta(Resposta resposta) async {
    try {
      final response = await _apiClient.post(
        Endpoints.respostas,
        body: json.encode(resposta.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        return Resposta.fromJson(json.decode(response.body));
      } else {
        throw RespostaException(
          'Falha ao criar resposta: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw RespostaException('Erro ao criar resposta', e.toString());
    }
  }

  Future<List<Resposta>> listarRespostas() async {
    try {
      final response = await _apiClient.get(
        Endpoints.respostas,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Resposta.fromJson(e)).toList();
      } else {
        throw RespostaException(
          'Falha ao listar respostas: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw RespostaException('Erro ao listar respostas', e.toString());
    }
  }
}

class RespostaException implements Exception {
  final String message;
  final String details;

  RespostaException(this.message, [this.details = '']);

  @override
  String toString() => '$message${details.isNotEmpty ? ': $details' : ''}';
}

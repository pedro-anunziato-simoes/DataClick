import 'package:flutter/material.dart';
import 'package:mobile/api/models/recrutador.dart';
import 'package:mobile/api/services/recrutador_service.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ViewModelState {}

class InitialState extends ViewModelState {}

class LoadingState extends ViewModelState {}

class SuccessState<T> extends ViewModelState {
  final T data;
  SuccessState(this.data);
}

class ErrorState extends ViewModelState {
  final String message;
  ErrorState(this.message);
}

class RecrutadorViewModel extends ChangeNotifier {
  final RecrutadorService _service;
  final Logger _logger = Logger('RecrutadorViewModel');
  final http.Client _client;

  ViewModelState _state = InitialState();
  Recrutador? _recrutador;

  List<Recrutador> _recrutadores = [];
  List<Recrutador> get recrutadores => _recrutadores;

  bool get isLoading => _state is LoadingState;
  String? get errorMessage =>
      _state is ErrorState ? (_state as ErrorState).message : null;

  RecrutadorViewModel(this._service) : _client = http.Client();

  ViewModelState get state => _state;
  Recrutador? get recrutador => _recrutador;

  set state(ViewModelState newState) {
    _state = newState;
    notifyListeners();
  }

  set recrutador(Recrutador? newRecrutador) {
    _recrutador = newRecrutador;
    notifyListeners();
  }

  Future<void> carregarRecrutadorPorId(String recrutadorId) async {
    state = LoadingState();
    notifyListeners();

    try {
      recrutador = await _service.getRecrutadorById(recrutadorId);
      state = SuccessState(recrutador!);
      _logger.fine('Recrutador carregado com sucesso: ${recrutador?.nome}');
    } catch (e) {
      state = ErrorState('Falha ao carregar recrutador: ${e.toString()}');
      _logger.severe('Erro ao carregar recrutador: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> carregarRecrutadorLogado() async {
    try {
      state = LoadingState();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await _client.get(
        Uri.parse('http://localhost:8080/recrutadores/info'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Debug - Resposta do servidor: $jsonResponse');
        recrutador = Recrutador.fromJson(jsonResponse);
        print('Debug - Eventos carregados: ${recrutador?.eventos?.length}');
        if (recrutador?.eventos != null) {
          print(
            'Debug - Nomes dos eventos: ${recrutador?.eventos?.map((e) => e.eventoTitulo).join(', ')}',
          );
        }
        state = SuccessState(recrutador);
      } else if (response.statusCode == 401) {
        throw Exception('Token inválido ou expirado');
      } else {
        throw Exception('Falha ao carregar recrutador: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar recrutador: $e');
      state = ErrorState(e.toString());
      rethrow;
    }
  }

  Future<void> carregarTodosRecrutadores() async {
    state = LoadingState();
    notifyListeners();

    try {
      _recrutadores = await _service.getRecrutadores();
      state = SuccessState(_recrutadores);
      _logger.fine('Recrutadores carregados com sucesso');
    } catch (e) {
      state = ErrorState('Falha ao carregar recrutadores: ${e.toString()}');
      _logger.severe('Erro ao carregar recrutadores: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> atualizarRecrutador({
    required String recrutadorId,
    required String nome,
    required String telefone,
    required String email,
  }) async {
    state = LoadingState();
    notifyListeners();

    try {
      recrutador = await _service.alterarRecrutador(
        recrutadorId: recrutadorId,
        nome: nome,
        telefone: telefone,
        email: email,
      );
      state = SuccessState(recrutador!);
      _logger.fine('Recrutador atualizado com sucesso: ${recrutador?.nome}');
    } catch (e) {
      state = ErrorState('Falha ao atualizar recrutador: ${e.toString()}');
      _logger.severe('Erro ao atualizar recrutador: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> alterarSenha(String recrutadorId, String novaSenha) async {
    state = LoadingState();
    notifyListeners();

    try {
      await _service.alterarSenha(novaSenha, recrutadorId);
      state = SuccessState(true);
      _logger.fine('Senha alterada com sucesso');
    } catch (e) {
      state = ErrorState('Falha ao alterar senha: ${e.toString()}');
      _logger.severe('Erro ao alterar senha: $e');
    } finally {
      notifyListeners();
    }
  }

  /*
  Future<void> criarRecrutador({
    required String nome,
    required String senha,
    required String telefone,
    required String email,
    required String adminId,
  }) async {
    state = LoadingState();
    notifyListeners();

    try {
      recrutador = await _service.criarRecrutador(
        nome: nome,
        email: email,
        telefone: telefone,
        senha: senha,
        adminId: adminId,
      );
      state = SuccessState(recrutador!);
      _logger.fine('Recrutador criado com sucesso: ${recrutador?.nome}');
    } catch (e) {
      state = ErrorState('Falha ao criar recrutador: ${e.toString()}');
      _logger.severe('Erro ao criar recrutador: $e');
    } finally {
      notifyListeners();
    }
  }
  */
  void limparEstado() {
    state = InitialState();
    recrutador = null;
    notifyListeners();
  }
}

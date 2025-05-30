import 'package:flutter/material.dart';
import 'package:mobile/api/models/recrutador.dart';
import 'package:mobile/api/services/recrutador_service.dart';
import 'package:logging/logging.dart';

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

class RecrutadorViewModel with ChangeNotifier {
  final RecrutadorService _recrutadorService;
  final Logger _logger = Logger('RecrutadorViewModel');

  ViewModelState _state = InitialState();
  ViewModelState get state => _state;

  Recrutador? _recrutador;
  Recrutador? get recrutador => _recrutador;

  List<Recrutador> _recrutadores = [];
  List<Recrutador> get recrutadores => _recrutadores;

  bool get isLoading => _state is LoadingState;
  String? get errorMessage =>
      _state is ErrorState ? (_state as ErrorState).message : null;

  RecrutadorViewModel(this._recrutadorService);

  Future<void> carregarRecrutadorPorId(String recrutadorId) async {
    _state = LoadingState();
    notifyListeners();

    try {
      _recrutador = await _recrutadorService.getRecrutadorById(recrutadorId);
      _state = SuccessState(_recrutador!);
      _logger.fine('Recrutador carregado com sucesso: ${_recrutador?.nome}');
    } catch (e) {
      _state = ErrorState('Falha ao carregar recrutador: ${e.toString()}');
      _logger.severe('Erro ao carregar recrutador: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> carregarRecrutadorPorEmail(String email) async {
    _state = LoadingState();
    notifyListeners();

    try {
      _recrutador = await _recrutadorService.getRecrutadorByEmail(email);
      _state = SuccessState(_recrutador!);
      _logger.fine(
        'Recrutador carregado por email com sucesso: ${_recrutador?.nome}',
      );
    } catch (e) {
      _state = ErrorState(
        'Falha ao carregar recrutador por email: ${e.toString()}',
      );
      _logger.severe('Erro ao carregar recrutador por email: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> carregarTodosRecrutadores() async {
    _state = LoadingState();
    notifyListeners();

    try {
      _recrutadores = await _recrutadorService.getRecrutadores();
      _state = SuccessState(_recrutadores);
      _logger.fine('Recrutadores carregados com sucesso');
    } catch (e) {
      _state = ErrorState('Falha ao carregar recrutadores: ${e.toString()}');
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
    _state = LoadingState();
    notifyListeners();

    try {
      _recrutador = await _recrutadorService.alterarRecrutador(
        recrutadorId: recrutadorId,
        nome: nome,
        telefone: telefone,
        email: email,
      );
      _state = SuccessState(_recrutador!);
      _logger.fine('Recrutador atualizado com sucesso: ${_recrutador?.nome}');
    } catch (e) {
      _state = ErrorState('Falha ao atualizar recrutador: ${e.toString()}');
      _logger.severe('Erro ao atualizar recrutador: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> alterarSenha(String recrutadorId, String novaSenha) async {
    _state = LoadingState();
    notifyListeners();

    try {
      await _recrutadorService.alterarSenha(novaSenha, recrutadorId);
      _state = SuccessState(true);
      _logger.fine('Senha alterada com sucesso');
    } catch (e) {
      _state = ErrorState('Falha ao alterar senha: ${e.toString()}');
      _logger.severe('Erro ao alterar senha: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> criarRecrutador({
    required String nome,
    required String senha,
    required String telefone,
    required String email,
    required String adminId,
  }) async {
    _state = LoadingState();
    notifyListeners();

    try {
      _recrutador = await _recrutadorService.criarRecrutador(
        nome: nome,
        email: email,
        telefone: telefone,
        senha: senha,
        adminId: adminId,
      );
      _state = SuccessState(_recrutador!);
      _logger.fine('Recrutador criado com sucesso: ${_recrutador?.nome}');
    } catch (e) {
      _state = ErrorState('Falha ao criar recrutador: ${e.toString()}');
      _logger.severe('Erro ao criar recrutador: $e');
    } finally {
      notifyListeners();
    }
  }

  void limparEstado() {
    _state = InitialState();
    _recrutador = null;
    notifyListeners();
  }
}

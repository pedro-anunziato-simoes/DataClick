import 'package:flutter/material.dart';
import 'package:mobile/api/models/administrador.dart';
import 'package:mobile/api/services/administrador_service.dart';
import 'package:mobile/api/services/api_exception.dart';
import 'package:mobile/api/repository/viewmodel/request_state.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdministradorViewModel extends ChangeNotifier {
  final AdministradorService _administradorService;
  final _logger = Logger('AdministradorViewModel');

  Administrador? _administrador;
  RequestState _state = const InitialState();

  AdministradorViewModel(this._administradorService) {
    _lerAdminDoCache();
  }

  Administrador? get administrador => _administrador;
  RequestState get state => _state;

  Future<void> _lerAdminDoCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('admin_json');
    if (jsonString != null) {
      try {
        _administrador = Administrador.fromJson(jsonDecode(jsonString));
        _state = SuccessState(_administrador!);
        notifyListeners();
      } catch (e) {
       
      }
    }
  }

  Future<void> _salvarAdminNoCache(Administrador admin) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('admin_json', jsonEncode(admin.toJson()));
  }

  Future<void> carregarAdministradorInfo() async {
    _logger.fine('Iniciando carregamento das informações do administrador');
    _state = LoadingState();
    notifyListeners();

    try {
      _administrador = await _administradorService.getAdministradorInfo();
      if (_administrador != null) {
        await _salvarAdminNoCache(_administrador!);
        _logger.fine(
          'Administrador carregado com sucesso: ${_administrador?.nome}',
        );
        _logger.fine('Dados do administrador:');
        _logger.fine('  - usuarioId: ${_administrador?.usuarioId}');
        _logger.fine('  - nome: ${_administrador?.nome}');
        _logger.fine('  - email: ${_administrador?.email}');
        _logger.fine('  - telefone: ${_administrador?.telefone}');
        _logger.fine('  - cnpj: ${_administrador?.cnpj}');
        _logger.fine(
          '  - adminEventos: ${_administrador?.adminEventos?.length ?? 0}',
        );
        _logger.fine(
          '  - adminRecrutadores: ${_administrador?.adminRecrutadores?.length ?? 0}',
        );
        _state = SuccessState(_administrador!);
      } else {
        _logger.severe('Administrador retornado é null');
        _state = ErrorState('Dados do administrador não encontrados');
      }
    } catch (e) {
      _state = ErrorState(
        'Falha ao carregar informações do administrador: ${e.toString()}',
      );
      _logger.severe('Erro ao carregar administrador: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<bool> alterarEmail(String email) async {
    _state = LoadingState();
    notifyListeners();

    try {
      await _administradorService.alterarEmail(email);
      if (_administrador != null) {
        _administrador = _administrador!.copyWith(email: email);
        await _salvarAdminNoCache(_administrador!);
        _state = SuccessState(_administrador!);
      }
      _logger.fine('Email do administrador alterado com sucesso');
      return true;
    } catch (e) {
      _state = ErrorState('Falha ao alterar email: ${e.toString()}');
      _logger.severe('Erro ao alterar email: $e');
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> alterarSenha(String senha) async {
    _state = LoadingState();
    notifyListeners();

    try {
      await _administradorService.alterarSenha(senha);
      _logger.fine('Senha do administrador alterada com sucesso');
      return true;
    } catch (e) {
      _state = ErrorState('Falha ao alterar senha: ${e.toString()}');
      _logger.severe('Erro ao alterar senha: $e');
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> atualizarPerfil({
    String? nome,
    String? email,
    String? telefone,
    String? cnpj,
  }) async {
    _state = LoadingState();
    notifyListeners();

    try {
      if (email != null && email != _administrador?.email) {
        await _administradorService.alterarEmail(email);
      }
      if (_administrador != null) {
        _administrador = _administrador!.copyWith(
          nome: nome ?? _administrador!.nome,
          email: email ?? _administrador!.email,
          telefone: telefone ?? _administrador!.telefone,
          cnpj: cnpj ?? _administrador!.cnpj,
        );
        await _salvarAdminNoCache(_administrador!);
        _state = SuccessState(_administrador!);
      }
      _logger.fine('Perfil do administrador atualizado com sucesso');
      return true;
    } catch (e) {
      _state = ErrorState('Falha ao atualizar perfil: ${e.toString()}');
      _logger.severe('Erro ao atualizar perfil: $e');
      return false;
    } finally {
      notifyListeners();
    }
  }

  void clearError() {
    if (_state is ErrorState) {
      _state = const InitialState();
      notifyListeners();
    }
  }

  void reset() {
    _administrador = null;
    _state = const InitialState();
    notifyListeners();
  }
}

class Logger {
  final String name;

  Logger(this.name);

  void fine(String message) {
    debugPrint('[$name] FINE: $message');
  }

  void severe(String message) {
    debugPrint('[$name] SEVERE: $message');
  }
}

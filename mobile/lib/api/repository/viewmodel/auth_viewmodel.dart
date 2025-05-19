import 'package:flutter/material.dart';
import 'package:mobile/api/models/recrutador.dart';
import 'package:mobile/api/models/user.dart';
import 'package:mobile/api/services/auth_service.dart';
import 'package:mobile/api/services/recrutador_service.dart';
import 'package:mobile/api/services/api_exception.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService;
  final RecrutadorService _recrutadorService;
  User? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;

  AuthViewModel({
    required AuthService authService,
    required RecrutadorService recrutadorService,
  }) : _authService = authService,
       _recrutadorService = recrutadorService;

  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  bool get isAdmin => _currentUser?.tipo == 'admin';
  bool get isRecruiter => _currentUser?.tipo == 'recrutador';

  Future<void> initialize() async {
    await _loadCurrentUser();
  }

  String? _getErrorMessage(dynamic error) {
    if (error is ApiException) {
      return error.message;
    } else if (error is String) {
      return error;
    }
    return 'Ocorreu um erro desconhecido';
  }

  Future<bool> login(String email, String senha) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

    try {
      final success = await _authService.login(email, senha);
      if (success) {
        await _loadCurrentUser();
      }
      return success;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String nome,
    required String email,
    required String telefone,
    required String cnpj,
    required String senha,
  }) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

    try {
      final success = await _authService.register(
        nome: nome,
        email: email,
        telefone: telefone,
        cnpj: cnpj,
        senha: senha,
      );
      return success;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registerRecrutador({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

    try {
      final recrutadorData = RecrutadorCreateDTO(
        nome: nome,
        email: email,
        telefone: telefone,
        senha: senha,
      );

      final recrutador = await _recrutadorService.criarRecrutador(
        recrutadorData,
      );
      if (recrutador != null) {
        return await login(email, senha);
      }
      return false;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _currentUser = null;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _authService.getCurrentUser();
      _currentUser = user;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      _currentUser = null;
    }
    notifyListeners();
  }

  Future<bool> isAuthenticated() async {
    try {
      final isAuth = await _authService.isAuthenticated();
      if (isAuth && _currentUser == null) {
        await _loadCurrentUser();
      }
      return isAuth && _currentUser != null;
    } catch (e) {
      return false;
    }
  }

  String? getToken() {
    return _authService.getToken();
  }

  Future<bool> updateProfile({
    String? nome,
    String? email,
    String? telefone,
  }) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          nome: nome ?? _currentUser!.nome,
          email: email ?? _currentUser!.email,
          telefone: telefone ?? _currentUser!.telefone,
        );
      }

      return true;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Recrutador>> getRecrutadores() async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

    try {
      return await _recrutadorService.getRecrutadores();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> atualizarRecrutador({
    required String recrutadorId,
    required RecrutadorUpdateDTO recrutadorData,
  }) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

    try {
      await _recrutadorService.alterarRecrutador(
        recrutadorId: recrutadorId,
        recrutadorData: recrutadorData,
      );
      return true;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> excluirRecrutador(String recrutadorId) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

    try {
      await _recrutadorService.excluirRecrutador(recrutadorId);
      return true;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:mobile/api/models/administrador.dart';
import 'package:mobile/api/models/recrutador.dart';
import 'package:mobile/api/services/auth_service.dart';
import 'package:mobile/api/services/api_exception.dart';
import 'package:intl/intl.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService;
  bool _isLoading = false;
  String? _errorMessage;
  dynamic _currentUser;
  DateTime? _lastLogin;

  AuthViewModel(this._authService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  dynamic get currentUser => _currentUser;
  DateTime? get lastLogin => _lastLogin;
  bool get isAuthenticated => _authService.isAuthenticated();
  bool get isAdmin => _currentUser is Administrador;
  bool get isRecruiter => _currentUser is Recrutador;

  Future<void> initialize() async {
    _startLoading();
    try {
      if (isAuthenticated) {
        await _loadCurrentUser();
        _lastLogin = DateTime.now();
      }
    } catch (e) {
      _setError('Erro ao carregar dados do usuário');
    } finally {
      _stopLoading();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _startLoading();
      _clearError();

      final success = await _authService.login(email, password);

      if (!success) {
        _setError('Credenciais inválidas ou serviço indisponível');
        return false;
      }

      await _loadCurrentUser();
      _lastLogin = DateTime.now();

      if (_currentUser == null) {
        _setError('Falha ao carregar dados do usuário');
        return false;
      }

      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Ocorreu um erro inesperado durante o login');
      return false;
    } finally {
      _stopLoading();
    }
  }

  Future<bool> loginRecruiter(String email, String password) async {
    try {
      _startLoading();
      _clearError();

      final success = await _authService.login(email, password);

      if (!success) {
        _setError('Credenciais inválidas ou serviço indisponível');
        return false;
      }

      await _loadCurrentUser();
      _lastLogin = DateTime.now();

      if (_currentUser == null || !isRecruiter) {
        _setError('Falha ao carregar dados do recrutador');
        return false;
      }

      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Ocorreu um erro inesperado durante o login');
      return false;
    } finally {
      _stopLoading();
    }
  }

  Future<bool> register({
    required String nome,
    required String email,
    required String telefone,
    required String cnpj,
    required String senha,
  }) async {
    try {
      _startLoading();
      _clearError();

      await _authService.register(
        nome: nome,
        email: email,
        telefone: telefone,
        cnpj: cnpj,
        senha: senha,
      );

      final loginSuccess = await _authService.login(email, senha);

      if (loginSuccess) {
        await _loadCurrentUser();
        _lastLogin = DateTime.now();
        return true;
      } else {
        _setError('Registro realizado, mas falha no login automático');
        return false;
      }
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Ocorreu um erro inesperado durante o registro');
      return false;
    } finally {
      _stopLoading();
    }
  }

  Future<bool> registerRecruiter({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
    required String empresa,
    required String cargo,
  }) async {
    try {
      _startLoading();
      _clearError();

      await _authService.registerRecruiter(
        nome: nome,
        email: email,
        telefone: telefone,
        senha: senha,
        empresa: empresa,
        cargo: cargo,
      );

      final loginSuccess = await _authService.login(email, senha);

      if (loginSuccess) {
        await _loadCurrentUser();
        _lastLogin = DateTime.now();
        return true;
      } else {
        _setError('Registro realizado, mas falha no login automático');
        return false;
      }
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Ocorreu um erro inesperado durante o registro de recrutador');
      return false;
    } finally {
      _stopLoading();
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      _currentUser = await _authService.getCurrentUser();
      notifyListeners();

      if (_currentUser == null) {
        await _authService.logout();
      }
    } catch (e) {
      await _authService.logout();
      _currentUser = null;
      notifyListeners();
      throw Exception('Falha ao carregar dados do usuário');
    }
  }

  Future<void> logout() async {
    try {
      _startLoading();
      await _authService.logout();
      _currentUser = null;
      _lastLogin = null;
      _clearError();
    } catch (e) {
      _setError('Falha ao realizar logout');
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      if (isAuthenticated) {
        await _loadCurrentUser();
        _lastLogin = DateTime.now();
      }
    } catch (e) {
      debugPrint('Erro ao verificar status de autenticação: $e');
    }
  }

  void _startLoading() {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
  }

  void _stopLoading() {
    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  String get formattedLastLogin {
    return _lastLogin != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(_lastLogin!)
        : 'N/A';
  }

  String get userRole {
    if (isAdmin) return 'Administrador';
    if (isRecruiter) return 'Recrutador';
    return 'Usuário';
  }

  Future<void> updateProfile({
    String? nome,
    String? email,
    String? telefone,
  }) async {
    try {
      _startLoading();
      _clearError();

      notifyListeners();
    } catch (e) {
      _setError('Falha ao atualizar perfil: ${e.toString()}');
      rethrow;
    } finally {
      _stopLoading();
    }
  }
}

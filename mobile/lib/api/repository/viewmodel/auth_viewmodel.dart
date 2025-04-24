import 'package:flutter/material.dart';
import 'package:mobile/api/models/administrador.dart';
import 'package:mobile/api/services/auth_service.dart';
import 'package:mobile/api/services/api_exception.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService;
  bool _isLoading = false;
  String? _errorMessage;
  Administrador? _currentUser;

  AuthViewModel(this._authService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Administrador? get currentUser => _currentUser;
  bool get isAuthenticated => _authService.isAuthenticated();

  Future<bool> login(String email, String password) async {
    try {
      _startLoading();
      _clearError();
      print('[AuthViewModel] Iniciando login para $email');

      final success = await _authService.login(email, password);

      if (!success) {
        _setError('Credenciais inválidas ou serviço indisponível');
        return false;
      }

      await _loadCurrentUser();

      if (_currentUser == null) {
        _setError('Falha ao carregar dados do usuário');
        return false;
      }

      print(
        '[AuthViewModel] Login realizado com sucesso para ${_currentUser?.email}',
      );
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      print('[AuthViewModel] Erro de API: ${e.message}');
      return false;
    } catch (e) {
      _setError('Ocorreu um erro inesperado durante o login');
      print('[AuthViewModel] Erro inesperado: $e');
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
      print('[AuthViewModel] Iniciando registro para $email');

      await _authService.register(
        nome: nome,
        email: email,
        telefone: telefone,
        cnpj: cnpj,
        senha: senha,
      );

      print('[AuthViewModel] Registro realizado com sucesso');
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      print('[AuthViewModel] Erro de API: ${e.message}');
      return false;
    } catch (e) {
      _setError('Ocorreu um erro inesperado durante o registro');
      print('[AuthViewModel] Erro inesperado: $e');
      return false;
    } finally {
      _stopLoading();
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      _currentUser = await _authService.getCurrentUser();
      notifyListeners();

      if (_currentUser != null) {
        print('[AuthViewModel] Usuário carregado: ${_currentUser?.email}');
      } else {
        print('[AuthViewModel] Nenhum usuário autenticado encontrado');
        await _authService.logout();
      }
    } catch (e) {
      print('[AuthViewModel] Erro ao carregar usuário: $e');
      await _authService.logout();
      _currentUser = null;
      notifyListeners();
      throw ('Falha ao carregar dados do usuário');
    }
  }

  Future<void> logout() async {
    try {
      _startLoading();
      print('[AuthViewModel] Iniciando logout');

      await _authService.logout();
      _currentUser = null;
      _clearError();

      print('[AuthViewModel] Logout realizado com sucesso');
    } catch (e) {
      _setError('Falha ao realizar logout');
      print('[AuthViewModel] Erro no logout: $e');
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      if (isAuthenticated) {
        print('[AuthViewModel] Verificando status de autenticação');
        await _loadCurrentUser();
      }
    } catch (e) {
      print('[AuthViewModel] Erro ao verificar status de autenticação: $e');
    }
  }

  void _startLoading() {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
      print('[AuthViewModel] Loading iniciado');
    }
  }

  void _stopLoading() {
    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
      print('[AuthViewModel] Loading finalizado');
    }
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
    print('[AuthViewModel] Erro definido: $message');
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
      print('[AuthViewModel] Erro limpo');
    }
  }
}

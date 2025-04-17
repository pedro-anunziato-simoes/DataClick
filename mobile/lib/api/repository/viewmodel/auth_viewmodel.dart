import 'package:flutter/foundation.dart';
import 'package:mobile/api/services/administrador_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final AdministradorService _adminService;

  String? _adminId;
  bool _isAuthenticated = false;

  AuthViewModel(this._adminService);

  String? get adminId => _adminId;
  bool get isAuthenticated => _isAuthenticated;

  // Definir adminId manualmente (principal método que será usado)
  void setAdminId(String id) {
    _adminId = id;
    _isAuthenticated = true;
    _saveToPrefs(); // Salva nas preferências para persistência
    notifyListeners();
  }

  // Método para salvar o ID nas preferências compartilhadas
  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_adminId != null) {
        await prefs.setString('admin_id', _adminId!);
        await prefs.setBool('is_authenticated', true);
      } else {
        await prefs.remove('admin_id');
        await prefs.setBool('is_authenticated', false);
      }
    } catch (e) {
      // Apenas log, não afeta a funcionalidade principal
      print('Erro ao salvar credenciais: $e');
    }
  }

  // Carrega o estado de autenticação das preferências
  Future<bool> loadAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString('admin_id');
      final savedAuth = prefs.getBool('is_authenticated') ?? false;

      if (savedId != null && savedAuth) {
        _adminId = savedId;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Erro ao carregar estado de autenticação: $e');
    }
    return false;
  }

  // Método de autenticação - deve ser implementado conforme sua API
  // Este é um exemplo genérico, substitua pela implementação real
  Future<bool> authenticate(String email, String senha) async {
    try {
      // Implementação fictícia - substitua pelo método real do seu serviço
      // Por exemplo: await _adminService.login(email, senha)

      // Para teste ou implementação temporária:
      // Simula um login bem-sucedido para fins de desenvolvimento
      await Future.delayed(const Duration(milliseconds: 500));

      // Exemplo: se for um email de administrador válido
      if (email.contains('@admin')) {
        final mockedId = 'admin-${DateTime.now().millisecondsSinceEpoch}';
        setAdminId(mockedId);
        return true;
      }

      return false;
    } catch (e) {
      print('Erro na autenticação: $e');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _adminId = null;
    _isAuthenticated = false;
    await _saveToPrefs();
    notifyListeners();
  }
}

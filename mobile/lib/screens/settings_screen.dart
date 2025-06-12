import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/services/administrador_service.dart';
import '../api/repository/viewmodel/auth_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final administradorService = Provider.of<AdministradorService>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF26A69A), Color(0xFF00796B)],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSettingsHeaderModern(),
                const SizedBox(height: 24),
                _buildProfileSectionModern(context, administradorService),
                const SizedBox(height: 24),
                _buildAppSettingsSectionModern(),
                const SizedBox(height: 24),
                _buildAccountActionsSectionModern(context, authViewModel),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsHeaderModern() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF26A69A), Color(0xFF00796B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF26A69A).withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.settings, size: 40, color: Colors.white),
          const SizedBox(height: 8),
          const Text(
            'Configurações',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSectionModern(
    BuildContext context,
    AdministradorService service,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Perfil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingsItem(
              context,
              icon: Icons.person,
              title: 'Editar Perfil',
              isDarkMode: false,
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            _buildDivider(false),
            _buildSettingsItem(
              context,
              icon: Icons.email,
              title: 'Alterar Email',
              isDarkMode: false,
              onTap: () => _showChangeEmailDialog(context, false),
            ),
            _buildDivider(false),
            _buildSettingsItem(
              context,
              icon: Icons.lock,
              title: 'Alterar Senha',
              isDarkMode: false,
              onTap: () => _showChangePasswordDialog(context, service, false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSettingsSectionModern() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferências do App',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildSwitchItem(
              title: 'Notificações',
              subtitle: 'Receber notificações importantes',
              value: true,
              isDarkMode: false,
              onChanged: (value) {},
            ),
            _buildDivider(false),
            _buildSwitchItem(
              title: 'Tema Escuro',
              subtitle: 'Ativar modo escuro',
              value: false,
              isDarkMode: false,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountActionsSectionModern(
    BuildContext context,
    AuthViewModel authViewModel,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEF5350), Color(0xFFE53935)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ações da Conta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingsItem(
              context,
              icon: Icons.help,
              title: 'Ajuda e Suporte',
              isDarkMode: false,
              onTap: () {},
            ),
            _buildDivider(false),
            _buildSettingsItem(
              context,
              icon: Icons.privacy_tip,
              title: 'Privacidade e Termos',
              isDarkMode: false,
              onTap: () {},
            ),
            _buildDivider(false),
            _buildSettingsItem(
              context,
              icon: Icons.exit_to_app,
              title: 'Sair',
              isDarkMode: false,
              isLogout: true,
              onTap: () => _confirmLogout(context, authViewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isDarkMode,
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : const Color(0xFF26A69A),
      ),
      title: Text(
        title,
        style: TextStyle(
          color:
              isLogout
                  ? Colors.red
                  : (isDarkMode ? Colors.white : Colors.black87),
        ),
      ),
      trailing:
          isLogout
              ? null
              : Icon(
                Icons.chevron_right,
                color: isDarkMode ? Colors.grey[400]! : Colors.grey[600]!,
              ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required String subtitle,
    required bool value,
    required bool isDarkMode,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDarkMode ? Colors.grey[400]! : Colors.grey[600]!,
        ),
      ),
      value: value,
      activeColor: const Color(0xFF26A69A),
      inactiveTrackColor: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
      onChanged: onChanged,
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
      height: 1,
    );
  }

  void _showChangeEmailDialog(BuildContext context, bool isDarkMode) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Alterar Email',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
          ),
          backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
          content: TextField(
            controller: emailController,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              labelText: 'Novo Email',
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.grey[400]! : Colors.grey[600]!,
              ),
              hintText: 'digite@seuemail.com',
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.grey[500]! : Colors.grey[400]!,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                ),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF26A69A),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Email alterado com sucesso!'),
                    backgroundColor:
                        isDarkMode ? Colors.grey[800]! : Colors.white,
                  ),
                );
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showChangePasswordDialog(
    BuildContext context,
    AdministradorService service,
    bool isDarkMode,
  ) async {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Alterar Senha',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
          ),
          backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: 'Senha Atual',
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.grey[400]! : Colors.grey[600]!,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: 'Nova Senha',
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.grey[400]! : Colors.grey[600]!,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF26A69A),
              ),
              onPressed: () async {
                try {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Senha alterada com sucesso!'),
                        backgroundColor:
                            isDarkMode ? Colors.grey[800]! : Colors.white,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro: ${e.toString()}'),
                        backgroundColor:
                            isDarkMode ? Colors.grey[800]! : Colors.white,
                      ),
                    );
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmLogout(BuildContext context, AuthViewModel authViewModel) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Sair',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            backgroundColor:
                isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
            content: Text(
              'Deseja realmente sair do aplicativo?',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  authViewModel.logout();
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Sair'),
              ),
            ],
          ),
    );
  }
}

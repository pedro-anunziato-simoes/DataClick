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
      backgroundColor:
          isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFF26A69A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Configurações'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildSettingsHeader(isDarkMode),
                    const SizedBox(height: 24),
                    _buildProfileSection(
                      context,
                      administradorService,
                      isDarkMode,
                    ),
                    const SizedBox(height: 24),
                    _buildAppSettingsSection(isDarkMode),
                    const SizedBox(height: 24),
                    _buildAccountActionsSection(
                      context,
                      isDarkMode,
                      authViewModel,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsHeader(bool isDarkMode) {
    return Column(
      children: [
        Icon(
          Icons.settings,
          size: 40,
          color: isDarkMode ? Colors.white : const Color(0xFF26A69A),
        ),
        const SizedBox(height: 8),
        Text(
          'Configurações',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF26A69A),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    AdministradorService service,
    bool isDarkMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800]! : Colors.grey[50]!,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Perfil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF26A69A),
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingsItem(
              context,
              icon: Icons.person,
              title: 'Editar Perfil',
              isDarkMode: isDarkMode,
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            _buildDivider(isDarkMode),
            _buildSettingsItem(
              context,
              icon: Icons.email,
              title: 'Alterar Email',
              isDarkMode: isDarkMode,
              onTap: () => _showChangeEmailDialog(context, isDarkMode),
            ),
            _buildDivider(isDarkMode),
            _buildSettingsItem(
              context,
              icon: Icons.lock,
              title: 'Alterar Senha',
              isDarkMode: isDarkMode,
              onTap:
                  () => _showChangePasswordDialog(context, service, isDarkMode),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSettingsSection(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800]! : Colors.grey[50]!,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferências do App',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF26A69A),
              ),
            ),
            const SizedBox(height: 16),
            _buildSwitchItem(
              title: 'Notificações',
              subtitle: 'Receber notificações importantes',
              value: true,
              isDarkMode: isDarkMode,
              onChanged: (value) {},
            ),
            _buildDivider(isDarkMode),
            _buildSwitchItem(
              title: 'Tema Escuro',
              subtitle: 'Ativar modo escuro',
              value: isDarkMode,
              isDarkMode: isDarkMode,
              onChanged: (value) {

              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountActionsSection(
    BuildContext context,
    bool isDarkMode,
    AuthViewModel authViewModel,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800]! : Colors.grey[50]!,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ações da Conta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF26A69A),
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingsItem(
              context,
              icon: Icons.help,
              title: 'Ajuda e Suporte',
              isDarkMode: isDarkMode,
              onTap: () {},
            ),
            _buildDivider(isDarkMode),
            _buildSettingsItem(
              context,
              icon: Icons.privacy_tip,
              title: 'Privacidade e Termos',
              isDarkMode: isDarkMode,
              onTap: () {},
            ),
            _buildDivider(isDarkMode),
            _buildSettingsItem(
              context,
              icon: Icons.exit_to_app,
              title: 'Sair',
              isDarkMode: isDarkMode,
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
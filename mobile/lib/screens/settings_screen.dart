import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/services/administrador_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final administradorService = Provider.of<AdministradorService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF26A69A),
      appBar: AppBar(
        title: const Text('Configurações'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  children: [
                    _buildSettingsHeader(),
                    const SizedBox(height: 24),
                    _buildProfileSection(context, administradorService),
                    const SizedBox(height: 24),
                    _buildAppSettingsSection(),
                    const SizedBox(height: 24),
                    _buildAccountActionsSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsHeader() {
    return Column(
      children: [
        Icon(Icons.settings, size: 40, color: const Color(0xFF26A69A)),
        const SizedBox(height: 8),
        Text(
          'Configurações',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF26A69A),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    AdministradorService service,
  ) {
    return Card(
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
                color: const Color(0xFF26A69A),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.person, color: const Color(0xFF26A69A)),
              title: const Text('Editar Perfil'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.email, color: const Color(0xFF26A69A)),
              title: const Text('Alterar Email'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showChangeEmailDialog(context),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.lock, color: const Color(0xFF26A69A)),
              title: const Text('Alterar Senha'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showChangePasswordDialog(context, service),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSettingsSection() {
    return Card(
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
                color: const Color(0xFF26A69A),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Notificações'),
              subtitle: const Text('Receber notificações importantes'),
              value: true,
              activeColor: const Color(0xFF26A69A),
              onChanged: (value) {},
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Tema Escuro'),
              subtitle: const Text('Ativar modo escuro'),
              value: false,
              activeColor: const Color(0xFF26A69A),
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountActionsSection(BuildContext context) {
    return Card(
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
                color: const Color(0xFF26A69A),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.help, color: const Color(0xFF26A69A)),
              title: const Text('Ajuda e Suporte'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.privacy_tip, color: const Color(0xFF26A69A)),
              title: const Text('Privacidade e Termos'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Sair', style: TextStyle(color: Colors.red)),
              onTap: () => _confirmLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final emailController = TextEditingController();
        return AlertDialog(
          title: const Text('Alterar Email'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Novo Email',
              hintText: 'digite@seuemail.com',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF26A69A),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email alterado com sucesso!')),
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
  ) async {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alterar Senha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                decoration: const InputDecoration(labelText: 'Senha Atual'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(labelText: 'Nova Senha'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF26A69A),
              ),
              onPressed: () async {
                try {
                  // Implemente o método changePassword no AdministradorService
                  // await service.changePassword(
                  //   oldPasswordController.text,
                  //   newPasswordController.text,
                  // );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Senha alterada com sucesso!'),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro: ${e.toString()}')),
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

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sair'),
            content: const Text('Deseja realmente sair do aplicativo?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
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

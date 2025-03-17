import 'package:flutter/material.dart';
import '../widgets/logo_widget.dart';

class FormsScreen extends StatelessWidget {
  const FormsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
            child: const Text('Menu', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          const LogoWidget(),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildFormCard(
                    title: 'Formulário de Cadastro',
                    description: 'Formulário para cadastro de novos usuários',
                    onTap: () {
                      // Navegação para o formulário específico
                    },
                    onEdit: () {
                      // Navegação para a tela de edição do formulário
                      Navigator.pushNamed(context, '/edit-form');
                    },
                    onUseTemplate: () {
                      // Ação para usar o formulário como modelo
                      _useTemplate(context, 'Formulário de Cadastro');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFormCard(
                    title: 'Pesquisa de Satisfação',
                    description: 'Avalie nossos serviços',
                    onTap: () {
                      // Navegação para o formulário específico
                    },
                    onEdit: () {
                      // Navegação para a tela de edição do formulário
                      Navigator.pushNamed(context, '/edit-form');
                    },
                    onUseTemplate: () {
                      // Ação para usar o formulário como modelo
                      _useTemplate(context, 'Pesquisa de Satisfação');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFormCard(
                    title: 'Relatório de Atividades',
                    description: 'Registre suas atividades diárias',
                    onTap: () {
                      // Navegação para o formulário específico
                    },
                    onEdit: () {
                      // Navegação para a tela de edição do formulário
                      Navigator.pushNamed(context, '/edit-form');
                    },
                    onUseTemplate: () {
                      // Ação para usar o formulário como modelo
                      _useTemplate(context, 'Relatório de Atividades');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegação para a tela de criação de formulários
          Navigator.pushNamed(context, '/create-form');
        },
        backgroundColor: const Color.from(alpha: 1, red: 0.906, green: 0.906, blue: 0.906),
        child: const Icon(Icons.add, color: Color(0xFF26A69A)),
      ),
    );
  }

  Widget _buildFormCard({
    required String title,
    required String description,
    required VoidCallback onTap,
    required VoidCallback onEdit,
    required VoidCallback onUseTemplate,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20, color: Colors.black54),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.content_copy, size: 20, color: Colors.black54),
                        onPressed: onUseTemplate,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.black54),
                  SizedBox(width: 8),
                  Text(
                    'Última atualização: 10/03/2025',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _useTemplate(BuildContext context, String formTitle) {
    // Lógica para usar o formulário como modelo
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Usar Modelo'),
          content: Text('Deseja criar um novo formulário com base em "$formTitle"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fechar o diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Navegar para a tela de criação de formulário com o modelo selecionado
                Navigator.pop(context); // Fechar o diálogo
                Navigator.pushNamed(
                  context,
                  '/create-form',
                  arguments: formTitle, // Passar o título como argumento
                );
              },
              child: Text('Usar Modelo'),
            ),
          ],
        );
      },
    );
  }
}
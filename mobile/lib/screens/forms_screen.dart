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
                  ),
                  const SizedBox(height: 16),
                  _buildFormCard(
                    title: 'Pesquisa de Satisfação',
                    description: 'Avalie nossos serviços',
                    onTap: () {
                      // Navegação para o formulário específico
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFormCard(
                    title: 'Relatório de Atividades',
                    description: 'Registre suas atividades diárias',
                    onTap: () {
                      // Navegação para o formulário específico
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
          // Ação para criar um novo formulário
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Color(0xFF26A69A)),
      ),
    );
  }

  Widget _buildFormCard({
    required String title,
    required String description,
    required VoidCallback onTap,
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
                  const Icon(Icons.arrow_forward_ios, size: 16),
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
}

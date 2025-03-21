import 'package:flutter/material.dart';

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
          // Removido o LogoWidget e a imagem arredondada
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildFormCard(
                    title: 'Formulário de Cadastro',
                    description: 'Formulário para cadastro de novos usuários',
                    onTap: () {},
                    onEdit: () {
                      Navigator.pushNamed(context, '/edit-form');
                    },
                    onUseTemplate: () {
                      _useTemplate(context, 'Formulário de Cadastro');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFormCard(
                    title: 'Pesquisa de Satisfação',
                    description: 'Avalie nossos serviços',
                    onTap: () {},
                    onEdit: () {
                      Navigator.pushNamed(context, '/edit-form');
                    },
                    onUseTemplate: () {
                      _useTemplate(context, 'Pesquisa de Satisfação');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFormCard(
                    title: 'Relatório de Atividades',
                    description: 'Registre suas atividades diárias',
                    onTap: () {},
                    onEdit: () {
                      Navigator.pushNamed(context, '/edit-form');
                    },
                    onUseTemplate: () {
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
          Navigator.pushNamed(context, '/create-form');
        },
        backgroundColor: const Color(0xFF26A69A),
        child: const Icon(Icons.add, color: Colors.white),
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
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.black54,
                        ),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.content_copy,
                          size: 20,
                          color: Colors.black54,
                        ),
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Usar Modelo'),
          content: Text(
            'Deseja criar um novo formulário com base em "$formTitle"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/create-form',
                  arguments: formTitle,
                );
              },
              child: const Text('Usar Modelo'),
            ),
          ],
        );
      },
    );
  }
}

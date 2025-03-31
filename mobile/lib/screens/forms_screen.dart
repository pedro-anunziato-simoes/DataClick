// forms_screen.dart - Versão melhorada
import 'package:flutter/material.dart';

class FormsScreen extends StatelessWidget {
  const FormsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF26A69A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        title: const Text('Formulários'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  _buildFormCard(
                    context,
                    title: 'Formulário de Cadastro',
                    description: 'Formulário para cadastro de novos usuários',
                    lastUpdate: '10/03/2025',
                  ),
                  const SizedBox(height: 16),
                  _buildFormCard(
                    context,
                    title: 'Pesquisa de Satisfação',
                    description: 'Avalie nossos serviços',
                    lastUpdate: '05/03/2025',
                  ),
                  const SizedBox(height: 16),
                  _buildFormCard(
                    context,
                    title: 'Relatório de Atividades',
                    description: 'Registre suas atividades diárias',
                    lastUpdate: '01/03/2025',
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

  Widget _buildFormCard(
    BuildContext context, {
    required String title,
    required String description,
    required String lastUpdate,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.pushNamed(context, '/edit-form');
                      } else if (value == 'copy') {
                        _useTemplate(context, title);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Editar'),
                        ),
                        const PopupMenuItem(
                          value: 'copy',
                          child: Text('Usar como modelo'),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(description, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Última atualização: $lastUpdate',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
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
              onPressed: () => Navigator.pop(context),
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
              child: const Text(
                'Usar Modelo',
                style: TextStyle(color: Color(0xFF26A69A)),
              ),
            ),
          ],
        );
      },
    );
  }
}

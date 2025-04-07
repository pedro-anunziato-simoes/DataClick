import 'package:flutter/material.dart';
import '../api/models/formulario.dart';
import '../api/services/formulario_service.dart';

class FormsScreen extends StatefulWidget {
  final String? adminId;
  final FormularioService formularioService;

  const FormsScreen({Key? key, this.adminId, required this.formularioService})
    : super(key: key);

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  List<Formulario> _formularios = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarFormularios();
  }

  Future<void> _carregarFormularios() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final formularios =
          widget.adminId != null
              ? await widget.formularioService.listarFormulariosPorAdmin(
                widget.adminId!,
              )
              : await widget.formularioService.listarTodosFormularios();

      setState(() {
        _formularios = formularios;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF26A69A),
      appBar: AppBar(
        title: const Text('Formulários'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (widget.adminId != null) {
                Navigator.pushNamed(
                  context,
                  '/create-form',
                  arguments: {'adminId': widget.adminId},
                ).then((_) => _carregarFormularios());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Acesso não autorizado')),
                );
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _carregarFormularios,
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
                : _errorMessage != null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Falha ao carregar formulários',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _carregarFormularios,
                        child: Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
                : _formularios.isEmpty
                ? Center(
                  child: Text(
                    'Nenhum formulário encontrado',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _formularios.length,
                  itemBuilder: (context, index) {
                    final formulario = _formularios[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      child: ListTile(
                        title: Text(formulario.titulo),
                        subtitle: Text(
                          'Campos: ${formulario.campos.length}',
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/create-form',
                                  arguments: {
                                    'adminId': widget.adminId,
                                    'formularioExistente': formulario,
                                  },
                                ).then((_) => _carregarFormularios());
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmarExclusao(formulario),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Exibir detalhes do formulário
                          _mostrarDetalhesFormulario(formulario);
                        },
                      ),
                    );
                  },
                ),
      ),
    );
  }

  void _confirmarExclusao(Formulario formulario) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Excluir Formulário'),
            content: Text(
              'Tem certeza que deseja excluir o formulário "${formulario.titulo}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await widget.formularioService.removerFormulario(
                      formulario.id,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Formulário excluído com sucesso!'),
                      ),
                    );
                    _carregarFormularios();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Erro ao excluir formulário: ${e.toString()}',
                        ),
                      ),
                    );
                  }
                },
                child: Text('Excluir'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
    );
  }

  void _mostrarDetalhesFormulario(Formulario formulario) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            expand: false,
            builder:
                (context, scrollController) => SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        formulario.titulo,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${formulario.id}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const Divider(height: 24),
                      Text(
                        'Campos do Formulário',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (formulario.campos.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Nenhum campo encontrado neste formulário.',
                          ),
                        )
                      else
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: formulario.campos.length,
                          separatorBuilder:
                              (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final campo = formulario.campos[index];
                            return ListTile(
                              title: Text(campo.titulo),
                              subtitle: Text('Tipo: ${campo.tipo}'),
                              trailing: Icon(
                                _getIconForFieldType(campo.tipo),
                                color: const Color(0xFF26A69A),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
          ),
    );
  }

  IconData _getIconForFieldType(String tipo) {
    switch (tipo) {
      case 'TEXTO':
        return Icons.text_fields;
      case 'SELECT':
        return Icons.list;
      case 'CHECKBOX':
        return Icons.check_box;
      default:
        return Icons.help_outline;
    }
  }
}

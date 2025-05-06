import 'package:flutter/material.dart';
import '../api/models/formulario.dart';
import '../api/services/formulario_service.dart';
import '../api/services/campo_service.dart';
import 'form_create_screen.dart';

class FormsScreen extends StatefulWidget {
  final bool isAdmin;
  final FormularioService formularioService;
  final CampoService campoService;

  const FormsScreen({
    super.key,
    required this.isAdmin,
    required this.formularioService,
    required this.campoService,
  });

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  late Future<List<Formulario>> _formulariosFuture;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadForms();
  }

  Future<void> _loadForms() {
    setState(() {
      _formulariosFuture = _carregarFormularios();
    });
    return _formulariosFuture;
  }

  Future<List<Formulario>> _carregarFormularios() async {
    try {
      return await widget.formularioService.getFormularios();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar formulários: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return [];
    }
  }

  Future<void> _refreshForms() async {
    await _loadForms();
    if (mounted) {
      _refreshIndicatorKey.currentState?.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulários'),
        actions: [
          if (widget.isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _navegarParaCriarFormulario,
              tooltip: 'Criar novo formulário',
            ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshForms,
        child: FutureBuilder<List<Formulario>>(
          future: _formulariosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Falha ao carregar formulários'),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshForms,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            final formularios = snapshot.data ?? [];
            if (formularios.isEmpty) {
              return Center(
                child: Text(
                  widget.isAdmin
                      ? 'Nenhum formulário criado'
                      : 'Nenhum formulário disponível',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: formularios.length,
              itemBuilder:
                  (context, index) => _buildFormularioCard(formularios[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormularioCard(Formulario formulario) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _mostrarDetalhesFormulario(formulario),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      formulario.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (widget.isAdmin) _buildAdminActions(formulario),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${formulario.campos.length} ${formulario.campos.length == 1 ? 'campo' : 'campos'}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminActions(Formulario formulario) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 20),
          color: Colors.blue,
          onPressed: () => _editarFormulario(formulario),
          tooltip: 'Editar formulário',
        ),
        IconButton(
          icon: const Icon(Icons.delete, size: 20),
          color: Colors.red,
          onPressed: () => _confirmarExclusao(formulario),
          tooltip: 'Excluir formulário',
        ),
      ],
    );
  }

  Future<void> _navegarParaCriarFormulario() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder:
            (context) => FormularioScreen(
              formularioService: widget.formularioService,
              campoService: widget.campoService,
            ),
      ),
    );

    if (result == true && mounted) {
      await _refreshForms();
    }
  }

  Future<void> _editarFormulario(Formulario formulario) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder:
            (context) => FormularioScreen(
              formularioExistente: formulario,
              formularioService: widget.formularioService,
              campoService: widget.campoService,
            ),
      ),
    );

    if (result == true && mounted) {
      await _refreshForms();
    }
  }

  void _confirmarExclusao(Formulario formulario) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: Text('Excluir "${formulario.titulo}" permanentemente?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _excluirFormulario(formulario);
                },
                child: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _excluirFormulario(Formulario formulario) async {
    try {
      await widget.formularioService.removerForms(formulario.id);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Formulário excluído com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
      await _refreshForms();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _mostrarDetalhesFormulario(Formulario formulario) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.9,
          minChildSize: 0.25,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    formulario.titulo,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Campos:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: formulario.campos.length,
                      itemBuilder: (context, index) {
                        final campo = formulario.campos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(campo.titulo),
                            subtitle: Text('Tipo: ${campo.tipo}'),
                            dense: true,
                          ),
                        );
                      },
                    ),
                  ),
                  if (widget.isAdmin)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar Campo'),
                        onPressed: () => _adicionarNovoCampo(formulario),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _adicionarNovoCampo(Formulario formulario) async {
    Navigator.pop(context);
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder:
            (context) => FormularioScreen(
              formIdForAddCampo: formulario.id,
              campoService: widget.campoService,
              formularioService: widget.formularioService,
              isEditingCampo: false,
            ),
      ),
    );

    if (result == true && mounted) {
      await _refreshForms();
    }
  }
}

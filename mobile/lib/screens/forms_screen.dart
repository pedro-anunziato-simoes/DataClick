import 'package:flutter/material.dart';
import '../api/models/formulario.dart';
import '../api/models/campo.dart';
import '../api/services/formulario_service.dart';
import '../api/services/campo_service.dart';
import 'form_create_screen.dart';

class FormsScreen extends StatefulWidget {
  final bool isAdmin;
  final FormularioService formularioService;
  final CampoService campoService;

  const FormsScreen({
    Key? key,
    required this.isAdmin,
    required this.formularioService,
    required this.campoService,
  }) : super(key: key);

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
          widget.isAdmin
              ? await widget.formularioService.getMeusFormularios()
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
      appBar: AppBar(
        title: const Text('Formulários'),
        actions: [
          if (widget.isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _navegarParaCriarFormulario(),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _carregarFormularios,
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? _buildErrorWidget()
                : _formularios.isEmpty
                ? _buildEmptyWidget()
                : _buildFormulariosList(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Falha ao carregar formulários'),
          const SizedBox(height: 8),
          Text(_errorMessage!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _carregarFormularios,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Text(
        widget.isAdmin
            ? 'Nenhum formulário criado ainda'
            : 'Nenhum formulário encontrado',
      ),
    );
  }

  Widget _buildFormulariosList() {
    return ListView.builder(
      itemCount: _formularios.length,
      itemBuilder: (context, index) {
        final formulario = _formularios[index];
        return Card(
          child: ListTile(
            title: Text(formulario.titulo),
            subtitle: Text('Campos: ${formulario.campos.length}'),
            trailing: widget.isAdmin ? _buildAdminActions(formulario) : null,
            onTap: () => _mostrarDetalhesFormulario(formulario),
          ),
        );
      },
    );
  }

  Widget _buildAdminActions(Formulario formulario) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => _editarFormulario(formulario),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmarExclusao(formulario),
        ),
      ],
    );
  }

  void _navegarParaCriarFormulario() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                CreateFormScreen(formularioService: widget.formularioService),
      ),
    ).then((_) => _carregarFormularios());
  }

  void _editarFormulario(Formulario formulario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CreateFormScreen(
              formularioExistente: formulario,
              formularioService: widget.formularioService,
            ),
      ),
    ).then((_) => _carregarFormularios());
  }

  void _confirmarExclusao(Formulario formulario) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Excluir Formulário'),
            content: Text(
              'Tem certeza que deseja excluir "${formulario.titulo}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => _excluirFormulario(formulario),
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
    Navigator.pop(context);
    try {
      await widget.formularioService.removerFormulario(formulario.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulário excluído com sucesso!')),
      );
      _carregarFormularios();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir: ${e.toString()}')),
      );
    }
  }

  void _mostrarDetalhesFormulario(Formulario formulario) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formulario.titulo,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Campos:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: formulario.campos.length,
                  itemBuilder: (context, index) {
                    final campo = formulario.campos[index];
                    return ListTile(
                      title: Text(campo.titulo),
                      subtitle: Text('Tipo: ${campo.tipo}'),
                    );
                  },
                ),
              ),
              if (widget.isAdmin)
                ElevatedButton(
                  onPressed: () => _adicionarNovoCampo(formulario.id),
                  child: const Text('Adicionar Campo'),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _adicionarNovoCampo(String formId) async {}
}

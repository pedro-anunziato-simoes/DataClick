import 'package:flutter/material.dart';
import '../api/models/formulario.dart';
import '../api/models/campo.dart';
import '../api/services/formulario_service.dart';
import '../api/services/campo_service.dart';

class FormsScreen extends StatefulWidget {
  final String? adminId;
  final FormularioService formularioService;
  final CampoService campoService;

  const FormsScreen({
    Key? key,
    this.adminId,
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

  Future<void> _adicionarCampoAFormulario(
    String formId,
    Campo novoCampo,
  ) async {
    try {
      await widget.campoService.adicionarCampo(formId, novoCampo);
      await _carregarFormularios();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campo adicionado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar campo: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF26A69A),
      appBar: AppBar(
        title: const Text('Formulários'),
        actions: [
          if (widget.adminId != null)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _navegarParaCriarFormulario(),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _carregarFormularios,
      child:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : _errorMessage != null
              ? _buildErrorWidget()
              : _formularios.isEmpty
              ? _buildEmptyWidget()
              : _buildFormulariosList(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Falha ao carregar formulários',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
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
        widget.adminId != null
            ? 'Nenhum formulário criado ainda'
            : 'Nenhum formulário encontrado',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildFormulariosList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _formularios.length,
      itemBuilder: (context, index) {
        final formulario = _formularios[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: ListTile(
            title: Text(formulario.titulo),
            subtitle: Text(
              'Campos: ${formulario.campos.length}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing:
                widget.adminId != null ? _buildAdminActions(formulario) : null,
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
    Navigator.pushNamed(
      context,
      '/create-form',
      arguments: {'adminId': widget.adminId},
    ).then((_) => _carregarFormularios());
  }

  void _editarFormulario(Formulario formulario) {
    Navigator.pushNamed(
      context,
      '/create-form',
      arguments: {'adminId': widget.adminId, 'formularioExistente': formulario},
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
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDragHandle(),
                  _buildFormularioHeader(formulario),
                  const Divider(height: 24),
                  _buildCamposList(formulario),
                  if (widget.adminId != null) _buildAddCampoButton(formulario),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildFormularioHeader(Formulario formulario) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          formulario.titulo,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'ID: ${formulario.id}',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildCamposList(Formulario formulario) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Campos do Formulário',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        formulario.campos.isEmpty
            ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Nenhum campo encontrado'),
            )
            : ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: formulario.campos.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final campo = formulario.campos[index];
                return ListTile(
                  title: Text(campo.titulo),
                  subtitle: Text('Tipo: ${campo.tipo}'),
                  trailing: Icon(
                    _getIconForFieldType(campo.tipo),
                    color: const Color(0xFF26A69A),
                  ),
                  onTap: () => _editarCampo(campo, formulario.id),
                );
              },
            ),
      ],
    );
  }

  Widget _buildAddCampoButton(Formulario formulario) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => _adicionarNovoCampo(formulario.id),
        child: const Text('Adicionar Campo'),
      ),
    );
  }

  Future<void> _adicionarNovoCampo(String formId) async {
    final novoCampo = await Navigator.pushNamed(
      context,
      '/add-campo',
      arguments: {'formId': formId},
    );

    if (novoCampo != null && novoCampo is Campo) {
      await _adicionarCampoAFormulario(formId, novoCampo);
    }
  }

  Future<void> _editarCampo(Campo campo, String formId) async {
    final campoEditado = await Navigator.pushNamed(
      context,
      '/edit-campo',
      arguments: {'campo': campo, 'formId': formId},
    );

    if (campoEditado != null && campoEditado is Campo) {
      try {
        await widget.campoService.alterarCampo(
          campo.campoId,
          tipo: campoEditado.tipo,
          status: campoEditado.resposta.valor,
        );
        await _carregarFormularios();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Campo atualizado com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar campo: ${e.toString()}')),
        );
      }
    }
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

import 'package:flutter/material.dart';
import '../api/models/formulario.dart';
import '../api/services/formulario_service.dart';
import '../api/services/campo_service.dart';
import 'form_create_screen.dart';

class FormsScreen extends StatefulWidget {
  static const String routeName = '/forms';

  final bool isAdmin;
  final FormularioService formularioService;
  final CampoService campoService;
  final String eventoId;
  final String adminId;

  const FormsScreen({
    super.key,
    required this.isAdmin,
    required this.formularioService,
    required this.campoService,
    required this.eventoId,
    required this.adminId,
  });

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  late Future<List<Formulario>> _formulariosFuture;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadForms();
  }

  Future<void> _loadForms() {
    setState(() {
      _isLoading = true;
      _formulariosFuture = _carregarFormularios();
    });
    return _formulariosFuture.whenComplete(
      () => setState(() => _isLoading = false),
    );
  }

  Future<List<Formulario>> _carregarFormularios() async {
    try {
      return await widget.formularioService.getFormulariosByEvento(
        widget.eventoId,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar formulários: [${e.toString()}'),
            backgroundColor: Colors.red,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navegarParaCriarFormulario,
        icon: const Icon(Icons.add),
        label: const Text('Novo Formulário'),
        backgroundColor: const Color(0xFF26A69A),
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refreshForms,
                child: FutureBuilder<List<Formulario>>(
                  future: _formulariosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return _buildErrorState(snapshot.error.toString());
                    }

                    final formularios = snapshot.data ?? [];
                    if (formularios.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: formularios.length,
                      itemBuilder:
                          (context, index) =>
                              _buildFormularioCard(formularios[index]),
                    );
                  },
                ),
              ),
    );
  }

  Widget _buildFormularioCard(Formulario formulario) {
    // print('DEBUG: Título do formulário no card: [31m${formulario.titulo}[0m');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
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
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Remover formulário',
                    onPressed: () => _confirmarExclusao(formulario),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (formulario.descricao != null &&
                  formulario.descricao!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    formulario.descricao!,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(
                      '${formulario.campos.length} ${formulario.campos.length == 1 ? 'campo' : 'campos'}',
                    ),
                    backgroundColor: Colors.grey[100],
                  ),
                  if (formulario.dataCriacao != null)
                    Text(
                      _formatarData(formulario.dataCriacao!),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                ],
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            widget.isAdmin
                ? 'Nenhum formulário criado'
                : 'Nenhum formulário disponível',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          if (widget.isAdmin) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _navegarParaCriarFormulario,
              icon: const Icon(Icons.add),
              label: const Text('Criar formulário'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF26A69A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Falha ao carregar formulários',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
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

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  Future<void> _navegarParaCriarFormulario() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder:
            (context) => FormularioScreen(
              formularioService: widget.formularioService,
              campoService: widget.campoService,
              eventoId: widget.eventoId,
              adminId: widget.adminId,
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
              eventoId: widget.eventoId,
              adminId: widget.adminId,
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
      setState(() => _isLoading = true);
      await widget.formularioService.removerFormulario(formulario.id);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Formulário excluído com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      await _refreshForms();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir: [${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _mostrarDetalhesFormulario(Formulario formulario) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.9,
          minChildSize: 0.25,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Padding(
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
                    if (formulario.descricao != null &&
                        formulario.descricao!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        child: Text(
                          formulario.descricao!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    if (formulario.dataCriacao != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Criado em: ${_formatarData(formulario.dataCriacao!)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
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
                              leading: _getTipoIcon(campo.tipo),
                              title: Text(campo.titulo),
                              subtitle: Text(
                                'Tipo: ${_getTipoDescricao(campo.tipo)}',
                              ),
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
              ),
            );
          },
        );
      },
    );
  }

  Icon _getTipoIcon(String tipo) {
    const icons = {
      'TEXTO': Icons.text_fields,
      'NUMERO': Icons.filter_1,
      'DATA': Icons.calendar_today,
      'CHECKBOX': Icons.check_box,
      'SELECT': Icons.radio_button_checked,
      'EMAIL': Icons.email,
    };
    return Icon(
      icons[tipo] ?? Icons.help_outline,
      color: const Color(0xFF26A69A),
    );
  }

  String _getTipoDescricao(String tipo) {
    const tipos = {
      'TEXTO': 'Texto',
      'NUMERO': 'Número',
      'DATA': 'Data',
      'CHECKBOX': 'Múltipla escolha',
      'SELECT': 'Seleção única',
      'EMAIL': 'E-mail',
    };
    return tipos[tipo] ?? tipo;
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
              eventoId: widget.eventoId,
              adminId: widget.adminId,
            ),
      ),
    );

    if (result == true && mounted) {
      await _refreshForms();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:mobile/api/models/campo.dart';
import 'package:mobile/api/models/formulario.dart';
import 'package:mobile/api/services/formulario_service.dart';
import 'package:mobile/api/services/campo_service.dart';
import 'package:mobile/api/services/api_exception.dart';

class FormularioScreen extends StatefulWidget {
  final Formulario? formularioExistente;
  final FormularioService formularioService;
  final CampoService campoService;
  final bool isEditingCampo;
  final Campo? campoToEdit;
  final String? formIdForAddCampo;
  final String eventoId;
  final String adminId;

  const FormularioScreen({
    super.key,
    this.formularioExistente,
    required this.formularioService,
    required this.campoService,
    this.isEditingCampo = false,
    this.campoToEdit,
    this.formIdForAddCampo,
    required this.eventoId,
    required this.adminId,
  });

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _campoTituloController = TextEditingController();
  final _opcaoController = TextEditingController();

  String _tipoCampoSelecionado = 'TEXTO';
  final List<String> _opcoes = [];
  final List<Campo> _campos = [];
  bool _isLoading = false;
  bool _isExpanded = false;
  bool _isCampoMode = false;

  final List<String> _tiposCampo = [
    'TEXTO',
    'NUMERO',
    'DATA',
    'CHECKBOX',
    'SELECT',
    'EMAIL',
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _isCampoMode = widget.isEditingCampo || widget.formIdForAddCampo != null;

    if (widget.formularioExistente != null) {
      _tituloController.text = widget.formularioExistente!.titulo;
      _campos.addAll(widget.formularioExistente!.campos);
    }

    if (widget.campoToEdit != null) {
      _campoTituloController.text = widget.campoToEdit!.titulo;
      _tipoCampoSelecionado = widget.campoToEdit!.tipo;
      if (widget.campoToEdit!.resposta['opcoes'] != null) {
        _opcoes.addAll(
          List<String>.from(widget.campoToEdit!.resposta['opcoes']),
        );
      }
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _campoTituloController.dispose();
    _opcaoController.dispose();
    super.dispose();
  }

  void _adicionarCampo() {
    if (_campoTituloController.text.isEmpty) {
      _showSnackBar('Informe o título do campo', isError: true);
      return;
    }

    final campo = Campo(
      titulo: _campoTituloController.text,
      tipo: _tipoCampoSelecionado,
      campoId: widget.campoToEdit?.campoId ?? '',
      resposta: {
        'tipo': _tipoCampoSelecionado,
        'valor': '',
        if (_tipoCampoSelecionado == 'SELECT' ||
            _tipoCampoSelecionado == 'CHECKBOX')
          'opcoes': _opcoes,
      },
    );

    setState(() {
      if (widget.campoToEdit != null) {
        // Se estiver editando, substitui o campo existente
        final index = _campos.indexWhere(
          (c) => c.campoId == widget.campoToEdit!.campoId,
        );
        if (index != -1) {
          _campos[index] = campo;
        }
      } else {
        _campos.add(campo);
      }
      _resetCampoForm();
    });
  }

  void _resetCampoForm() {
    _campoTituloController.clear();
    _opcaoController.clear();
    _opcoes.clear();
    _isExpanded = false;
  }

  void _adicionarOpcao() {
    if (_opcaoController.text.isEmpty) return;
    setState(() {
      _opcoes.add(_opcaoController.text);
      _opcaoController.clear();
    });
  }

  void _removerCampo(int index) {
    final campoRemovido = _campos[index].titulo;
    setState(() {
      _campos.removeAt(index);
    });
    _showSnackBar('Campo "$campoRemovido" removido!', isError: false);
  }

  Future<void> _salvarFormulario() async {
    if (!_isCampoMode && !_formKey.currentState!.validate()) {
      return;
    }

    if (_campos.isEmpty && !_isCampoMode) {
      _showSnackBar('Adicione pelo menos um campo', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isCampoMode) {
        await _handleCampoMode();
      } else {
        await _handleFormularioMode();
      }

      if (!mounted) return;
      _showSnackBar('Operação realizada com sucesso!', isError: false);
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      _showSnackBar(e.message, isError: true);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Erro: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleCampoMode() async {
    if (widget.campoToEdit != null) {
      await widget.campoService.alterarCampo(
        campoId: widget.campoToEdit!.campoId,
        tipo: _tipoCampoSelecionado,
        titulo: _campoTituloController.text,
      );
    } else {
      await widget.campoService.adicionarCampo(
        widget.formIdForAddCampo!,
        _campoTituloController.text,
        _tipoCampoSelecionado,
      );
    }
  }

  Future<void> _handleFormularioMode() async {
    if (widget.formularioExistente != null) {
      await widget.formularioService.alterarFormulario(
        formId: widget.formularioExistente!.id,
        titulo: _tituloController.text,
        campos: _campos,
      );
    } else {
      // 1. Cria o formulário sem campos
      var formularioCriado = await widget.formularioService.criarFormulario(
        titulo: _tituloController.text,
        eventoId: widget.eventoId,
        adminId: widget.adminId,
        campos: [], // Cria vazio
      );
      // 2. Adiciona cada campo usando o endpoint de campos
      for (final campo in _campos) {
        await widget.campoService.adicionarCampo(
          formularioCriado.id,
          campo.titulo,
          campo.tipo,
        );
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red[400] : const Color(0xFF26A69A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        title: Text(
          _isCampoMode
              ? widget.campoToEdit != null
                  ? 'Editar Campo'
                  : 'Adicionar Campo'
              : widget.formularioExistente != null
              ? 'Editar Formulário'
              : 'Criar Formulário',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isCampoMode)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _isLoading ? null : _salvarFormulario,
            ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return _isCampoMode
        ? _buildCampoForm()
        : Form(
          key: _formKey,
          child: Column(
            children: [
              _buildFormHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildAdicionarCampoCard(),
                      const SizedBox(height: 16),
                      if (_campos.isNotEmpty) _buildListaCampos(),
                      const SizedBox(height: 72),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }

  Widget _buildFormHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF26A69A),
      child: TextFormField(
        controller: _tituloController,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          labelText: 'Título do Formulário',
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white70),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          prefixIcon: const Icon(Icons.title, color: Colors.white),
          errorStyle: const TextStyle(color: Colors.yellow),
        ),
        validator:
            (value) =>
                value?.isEmpty ?? true
                    ? 'Informe o título do formulário'
                    : null,
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    return !_isLoading && !_isCampoMode
        ? FloatingActionButton.extended(
          onPressed: _salvarFormulario,
          label: const Text('SALVAR FORMULÁRIO'),
          icon: const Icon(Icons.save),
        )
        : null;
  }

  Widget _buildCampoForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _campoTituloController,
            decoration: _buildInputDecoration(
              label: 'Título do Campo',
              hintText: 'Ex: Nome, E-mail, Telefone...',
              icon: Icons.short_text,
            ),
          ),
          const SizedBox(height: 16),
          _buildTipoCampoDropdown(),
          if (_tipoCampoSelecionado == 'SELECT' ||
              _tipoCampoSelecionado == 'CHECKBOX')
            _buildOpcoesCampo(),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    String? hintText,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      prefixIcon: icon != null ? Icon(icon) : null,
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  Widget _buildTipoCampoDropdown() {
    return DropdownButtonFormField<String>(
      value: _tipoCampoSelecionado,
      decoration: _buildInputDecoration(
        label: 'Tipo de Campo',
        icon: _getTipoIcon(_tipoCampoSelecionado).icon,
      ),
      items:
          _tiposCampo
              .map(
                (tipo) => DropdownMenuItem(
                  value: tipo,
                  child: Row(
                    children: [
                      _getTipoIcon(tipo),
                      const SizedBox(width: 10),
                      Text(_getTipoDescricao(tipo)),
                    ],
                  ),
                ),
              )
              .toList(),
      onChanged: (value) {
        setState(() {
          _tipoCampoSelecionado = value!;
          if (value != 'SELECT' && value != 'CHECKBOX') {
            _opcoes.clear();
          }
        });
      },
    );
  }

  Widget _buildActionButtons() {
    if (widget.campoToEdit != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _salvarFormulario,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Salvar'),
            ),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _salvarFormulario,
          child:
              _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Adicionar Campo'),
        ),
      );
    }
  }

  Widget _buildAdicionarCampoCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF26A69A), Color(0xFF7DE2D1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withAlpha(60),
                    child: const Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF26A69A),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Adicionar Campo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _campoTituloController,
                    decoration: _buildInputDecoration(
                      label: 'Título do Campo',
                      hintText: 'Ex: Nome, E-mail, Telefone...',
                      icon: Icons.short_text,
                    ).copyWith(fillColor: Colors.white, filled: true),
                  ),
                  const SizedBox(height: 16),
                  _buildTipoCampoDropdown(),
                  if (_tipoCampoSelecionado == 'SELECT' ||
                      _tipoCampoSelecionado == 'CHECKBOX')
                    _buildOpcoesCampo(),
                  const SizedBox(height: 16),
                  _buildAddCampoButton(),
                ],
              ),
            ),
            crossFadeState:
                _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcoesCampo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Opções',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF26A69A),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _opcaoController,
                decoration: _buildInputDecoration(
                  label: 'Adicionar Opção',
                  hintText: 'Digite uma opção',
                  icon:
                      _tipoCampoSelecionado == 'SELECT'
                          ? Icons.radio_button_checked
                          : Icons.check_box,
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: _adicionarOpcao,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF26A69A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
        if (_opcoes.isNotEmpty) _buildOpcoesList(),
      ],
    );
  }

  Widget _buildOpcoesList() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Opções adicionadas:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _opcoes
                    .map(
                      (opcao) => Chip(
                        avatar: Icon(
                          _tipoCampoSelecionado == 'SELECT'
                              ? Icons.radio_button_checked
                              : Icons.check_box,
                          size: 18,
                        ),
                        label: Text(opcao),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        deleteIconColor: Colors.red[400],
                        onDeleted: () => setState(() => _opcoes.remove(opcao)),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCampoButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          _adicionarCampo();
          if (_campoTituloController.text.isNotEmpty) {
            _showSnackBar('Campo adicionado!', isError: false);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Campo'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF26A69A),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildListaCampos() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListHeader(),
          const Divider(),
          _campos.isEmpty ? _buildEmptyState() : _buildCamposList(),
        ],
      ),
    );
  }

  Widget _buildListHeader() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF26A69A).withAlpha(50),
          child: const Icon(Icons.list_alt, color: Color(0xFF26A69A)),
        ),
        const SizedBox(width: 16),
        const Text(
          'Campos do Formulário',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF26A69A),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF26A69A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _campos.length.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.add_box_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Nenhum campo adicionado',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Use o painel acima para adicionar campos',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildCamposList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _campos.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final campo = _campos[index];
        return Dismissible(
          key: ValueKey(campo.titulo + index.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.red[400],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => _removerCampo(index),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF26A69A).withAlpha(50),
              child: _getTipoIcon(campo.tipo),
            ),
            title: Text(
              campo.titulo,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(_getTipoDescricao(campo.tipo)),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _removerCampo(index),
              tooltip: 'Remover campo',
            ),
          ),
        );
      },
    );
  }
}

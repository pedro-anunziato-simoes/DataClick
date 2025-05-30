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
  final String? eventoId;

  const FormularioScreen({
    super.key,
    this.formularioExistente,
    required this.formularioService,
    required this.campoService,
    this.isEditingCampo = false,
    this.campoToEdit,
    this.formIdForAddCampo,
    this.eventoId,
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
  bool _campoObrigatorio = false;
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

    _isCampoMode = widget.isEditingCampo || widget.formIdForAddCampo != null;

    if (widget.formularioExistente != null) {
      _tituloController.text = widget.formularioExistente!.titulo;
      _campos.addAll(widget.formularioExistente!.campos);
    }

    if (widget.campoToEdit != null) {
      _campoTituloController.text = widget.campoToEdit!.titulo;
      _tipoCampoSelecionado = widget.campoToEdit!.tipo;
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o título do campo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _campos.add(
        Campo(
          titulo: _campoTituloController.text,
          tipo: _tipoCampoSelecionado,
          resposta: {'tipo': _tipoCampoSelecionado, 'valor': ''},
          campoId: widget.campoToEdit?.campoId ?? '',
        ),
      );

      _campoTituloController.clear();
      _opcaoController.clear();
      _opcoes.clear();
      _campoObrigatorio = false;
      _isExpanded = false;
    });
  }

  void _adicionarOpcao() {
    if (_opcaoController.text.isEmpty) return;
    setState(() {
      _opcoes.add(_opcaoController.text);
      _opcaoController.clear();
    });
  }

  void _removerCampo(int index) {
    setState(() {
      _campos.removeAt(index);
    });
  }

  Future<void> _salvarFormulario() async {
    if (!_formKey.currentState!.validate()) return;
    if (_campos.isEmpty && !_isCampoMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione pelo menos um campo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isCampoMode) {
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
      } else {
        if (widget.formularioExistente != null) {
          await widget.formularioService.alterarFormulario(
            formId: widget.formularioExistente!.id,
            titulo: _tituloController.text,
            campos: _campos,
          );
        } else {
          await widget.formularioService.criarFormulario(
            titulo: _tituloController.text,
            eventoId: widget.eventoId!,
            campos: _campos,
          );
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Operação realizada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getTipoDescricao(String tipo) {
    switch (tipo) {
      case 'TEXTO':
        return 'Texto';
      case 'NUMERO':
        return 'Número';
      case 'DATA':
        return 'Data';
      case 'CHECKBOX':
        return 'Múltipla escolha';
      case 'SELECT':
        return 'Seleção única';
      case 'EMAIL':
        return 'E-mail';
      default:
        return tipo;
    }
  }

  Icon _getTipoIcon(String tipo) {
    switch (tipo) {
      case 'TEXTO':
        return const Icon(Icons.text_fields, color: Color(0xFF26A69A));
      case 'NUMERO':
        return const Icon(Icons.filter_1, color: Color(0xFF26A69A));
      case 'DATA':
        return const Icon(Icons.calendar_today, color: Color(0xFF26A69A));
      case 'CHECKBOX':
        return const Icon(Icons.check_box, color: Color(0xFF26A69A));
      case 'SELECT':
        return const Icon(Icons.radio_button_checked, color: Color(0xFF26A69A));
      case 'EMAIL':
        return const Icon(Icons.email, color: Color(0xFF26A69A));
      default:
        return const Icon(Icons.help_outline, color: Color(0xFF26A69A));
    }
  }

  Widget _buildCampoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _campoTituloController,
          decoration: const InputDecoration(
            labelText: 'Título do Campo',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _tipoCampoSelecionado,
          decoration: const InputDecoration(
            labelText: 'Tipo de Campo',
            border: OutlineInputBorder(),
          ),
          items:
              _tiposCampo.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Row(
                    children: [
                      _getTipoIcon(tipo),
                      const SizedBox(width: 10),
                      Text(_getTipoDescricao(tipo)),
                    ],
                  ),
                );
              }).toList(),
          onChanged: (value) {
            setState(() {
              _tipoCampoSelecionado = value!;
              if (value != 'SELECT' && value != 'CHECKBOX') {
                _opcoes.clear();
              }
            });
          },
        ),
        const SizedBox(height: 24),
        if (widget.campoToEdit != null)
          Row(
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
          )
        else
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _salvarFormulario,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Adicionar Campo'),
            ),
          ),
      ],
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
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _isCampoMode
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildCampoForm(),
              )
              : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: const Color(0xFF26A69A),
                      child: TextFormField(
                        controller: _tituloController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
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
                          prefixIcon: const Icon(
                            Icons.title,
                            color: Colors.white,
                          ),
                          errorStyle: const TextStyle(color: Colors.yellow),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o título do formulário';
                          }
                          return null;
                        },
                      ),
                    ),
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
              ),
      floatingActionButton:
          !_isLoading && !_isCampoMode
              ? FloatingActionButton.extended(
                onPressed: _salvarFormulario,
                label: const Text('SALVAR FORMULÁRIO'),
                icon: const Icon(Icons.save),
              )
              : null,
    );
  }

  Widget _buildAdicionarCampoCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(
                      0xFF26A69A,
                    ).withValues(alpha: 0.2),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF26A69A),
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF26A69A),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _campoTituloController,
                    decoration: InputDecoration(
                      labelText: 'Título do Campo',
                      hintText: 'Ex: Nome, E-mail, Telefone...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.short_text),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _tipoCampoSelecionado,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Tipo de Campo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: _getTipoIcon(_tipoCampoSelecionado),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    items:
                        _tiposCampo.map((tipo) {
                          return DropdownMenuItem(
                            value: tipo,
                            child: Row(
                              children: [
                                _getTipoIcon(tipo),
                                const SizedBox(width: 10),
                                Text(_getTipoDescricao(tipo)),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _tipoCampoSelecionado = value!;
                        if (value != 'SELECT' && value != 'CHECKBOX') {
                          _opcoes.clear();
                        }
                      });
                    },
                  ),
                  if (_tipoCampoSelecionado == 'SELECT' ||
                      _tipoCampoSelecionado == 'CHECKBOX')
                    _buildOpcoesCampo(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _adicionarCampo,
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar Campo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF26A69A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
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
                decoration: InputDecoration(
                  labelText: 'Adicionar Opção',
                  hintText: 'Digite uma opção',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon:
                      _tipoCampoSelecionado == 'SELECT'
                          ? const Icon(Icons.radio_button_checked)
                          : const Icon(Icons.check_box),
                  filled: true,
                  fillColor: Colors.grey[50],
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
        if (_opcoes.isNotEmpty)
          Container(
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
                      _opcoes.map((opcao) {
                        return Chip(
                          avatar:
                              _tipoCampoSelecionado == 'SELECT'
                                  ? const Icon(
                                    Icons.radio_button_checked,
                                    size: 18,
                                  )
                                  : const Icon(Icons.check_box, size: 18),
                          label: Text(opcao),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          deleteIconColor: Colors.red[400],
                          onDeleted:
                              () => setState(() => _opcoes.remove(opcao)),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildListaCampos() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF26A69A).withValues(alpha: 0.2),
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
          ),
          const SizedBox(height: 8),
          const Divider(),
          _campos.isEmpty
              ? Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      Icons.add_box_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
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
              )
              : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _campos.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final campo = _campos[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: const Color(
                        0xFF26A69A,
                      ).withValues(alpha: 0.2),
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
                  );
                },
              ),
        ],
      ),
    );
  }
}

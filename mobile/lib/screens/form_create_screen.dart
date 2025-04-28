import 'package:flutter/material.dart';
import '../api/models/campo.dart';
import '../api/models/formulario.dart';
import '../api/models/resposta.dart';
import '../api/services/formulario_service.dart';
import '../api/services/campo_service.dart';

class CreateFormScreen extends StatefulWidget {
  final Formulario? formularioExistente;
  final FormularioService formularioService;
  final CampoService campoService;

  const CreateFormScreen({
    super.key,
    this.formularioExistente,
    required this.formularioService,
    required this.campoService,
  });

  @override
  State<CreateFormScreen> createState() => _CreateFormScreenState();
}

class _CreateFormScreenState extends State<CreateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _campoTituloController = TextEditingController();
  final _opcaoController = TextEditingController();

  String _tipoCampoSelecionado = 'TEXTO';
  bool _campoObrigatorio = false;
  final List<String> _opcoes = [];
  final List<Campo> _campos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.formularioExistente != null) {
      _tituloController.text = widget.formularioExistente!.titulo;
      _campos.addAll(widget.formularioExistente!.campos);
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
        const SnackBar(content: Text('Informe o título do campo')),
      );
      return;
    }

    setState(() {
      _campos.add(
        Campo(
          campoId: '',
          titulo: _campoTituloController.text,
          tipo: _tipoCampoSelecionado,
          resposta: Resposta(
            respostaId: '', // Added required respostaId
            tipo: _tipoCampoSelecionado,
            valor: '',
          ),
          isObrigatorio: _campoObrigatorio,
          opcoes:
              _tipoCampoSelecionado == 'SELECT' ||
                      _tipoCampoSelecionado == 'CHECKBOX'
                  ? List.from(_opcoes)
                  : null,
        ),
      );

      _campoTituloController.clear();
      _opcaoController.clear();
      _opcoes.clear();
      _campoObrigatorio = false;
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
    if (_campos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos um campo')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.formularioExistente != null) {
        await widget.formularioService.atualizarFormulario(
          formId: widget.formularioExistente!.id,
          titulo: _tituloController.text,
          campos: _campos,
        );
      } else {
        await widget.formularioService.criarFormulario(
          titulo: _tituloController.text,
          campos: _campos,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulário salvo com sucesso!')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar formulário: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.formularioExistente != null
              ? 'Editar Formulário'
              : 'Criar Formulário',
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título do Formulário',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o título do formulário';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildAdicionarCampoCard(),
                      if (_campos.isNotEmpty) _buildListaCampos(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _salvarFormulario,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Salvar Formulário'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildAdicionarCampoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adicionar Campo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
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
              items: const [
                DropdownMenuItem(value: 'TEXTO', child: Text('Texto')),
                DropdownMenuItem(value: 'NUMERO', child: Text('Número')),
                DropdownMenuItem(value: 'DATA', child: Text('Data')),
                DropdownMenuItem(value: 'CHECKBOX', child: Text('Checkbox')),
                DropdownMenuItem(value: 'SELECT', child: Text('Seleção')),
              ],
              onChanged:
                  (value) => setState(() => _tipoCampoSelecionado = value!),
            ),
            if (_tipoCampoSelecionado == 'SELECT' ||
                _tipoCampoSelecionado == 'CHECKBOX')
              _buildOpcoesCampo(),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Campo Obrigatório'),
              value: _campoObrigatorio,
              onChanged: (value) => setState(() => _campoObrigatorio = value!),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _adicionarCampo,
              child: const Text('Adicionar Campo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcoesCampo() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _opcaoController,
                decoration: const InputDecoration(
                  labelText: 'Adicionar Opção',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(icon: const Icon(Icons.add), onPressed: _adicionarOpcao),
          ],
        ),
        if (_opcoes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _opcoes.map((opcao) {
                    return Chip(
                      label: Text(opcao),
                      onDeleted: () => setState(() => _opcoes.remove(opcao)),
                    );
                  }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildListaCampos() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Campos do Formulário',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _campos.length,
                itemBuilder: (context, index) {
                  final campo = _campos[index];
                  return ListTile(
                    title: Text(campo.titulo),
                    subtitle: Text('Tipo: ${campo.tipo}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removerCampo(index),
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
}

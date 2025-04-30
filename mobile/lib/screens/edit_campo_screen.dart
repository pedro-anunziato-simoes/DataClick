import 'package:flutter/material.dart';
import '../api/services/campo_service.dart';
import '../api/models/campo.dart';

class EditCampoScreen extends StatefulWidget {
  final Campo campo;
  final String formId;
  final CampoService campoService;

  const EditCampoScreen({
    super.key,
    required this.campo,
    required this.formId,
    required this.campoService,
  });

  @override
  State<EditCampoScreen> createState() => _EditCampoScreenState();
}

class _EditCampoScreenState extends State<EditCampoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late String _tipoCampo;
  late bool _isRequired;
  bool _isLoading = false;
  final List<String> _opcoes = [];
  final TextEditingController _opcaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.campo.titulo);
    _descricaoController = TextEditingController(
      text: widget.campo.descricao ?? '',
    );
    _tipoCampo = widget.campo.tipo;
    _isRequired = widget.campo.isObrigatorio;
    _opcoes.addAll(widget.campo.opcoes ?? []);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _opcaoController.dispose();
    super.dispose();
  }

  void _adicionarOpcao() {
    if (_opcaoController.text.isEmpty) return;
    setState(() {
      _opcoes.add(_opcaoController.text);
      _opcaoController.clear();
    });
  }

  Future<void> _salvarCampo() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final campoData = {
          'titulo': _nomeController.text,
          'tipo': _tipoCampo,
          'isObrigatorio': _isRequired,
          if (_descricaoController.text.isNotEmpty)
            'descricao': _descricaoController.text,
          if (_opcoes.isNotEmpty) 'opcoes': _opcoes,
        };

        final campoAtualizado = await widget.campoService.alterarCampo(
          campoId: widget.campo.campoId,
          tipo: _tipoCampo,
          titulo: _nomeController.text,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Campo atualizado com sucesso!')),
        );
        Navigator.pop(context, campoAtualizado);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar campo: ${e.toString()}')),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Campo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Campo',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value?.isEmpty ?? true ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipoCampo,
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
                onChanged: (value) => setState(() => _tipoCampo = value!),
              ),
              if (_tipoCampo == 'SELECT' || _tipoCampo == 'CHECKBOX') ...[
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
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _adicionarOpcao,
                    ),
                  ],
                ),
                if (_opcoes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        _opcoes
                            .map(
                              (opcao) => Chip(
                                label: Text(opcao),
                                onDeleted:
                                    () => setState(() => _opcoes.remove(opcao)),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ],
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Campo Obrigatório'),
                value: _isRequired,
                onChanged: (value) => setState(() => _isRequired = value),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _salvarCampo,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

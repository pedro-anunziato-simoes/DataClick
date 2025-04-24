import 'package:flutter/material.dart';
import '../api/services/campo_service.dart';
import '../api/models/campo.dart';
import '../api/models/resposta.dart';

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

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.campo.titulo);
    _descricaoController = TextEditingController(
      text: widget.campo.descricao ?? '',
    );
    _tipoCampo = widget.campo.tipo;
    _isRequired = widget.campo.isObrigatorio;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _salvarCampo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final campoAtualizado = Campo(
          campoId: widget.campo.campoId,
          titulo: _nomeController.text,
          tipo: _tipoCampo,
          resposta: widget.campo.resposta,
          isObrigatorio: _isRequired,
          descricao:
              _descricaoController.text.isNotEmpty
                  ? _descricaoController.text
                  : null,
        );

        await widget.campoService.alterarCampo(
          widget.campo.campoId,
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
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
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
                  hintText: 'Digite o nome do campo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome para o campo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Digite a descrição do campo (opcional)',
                ),
                minLines: 2,
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipoCampo,
                decoration: const InputDecoration(labelText: 'Tipo de Campo'),
                items: const [
                  DropdownMenuItem(value: 'TEXTO', child: Text('Texto')),
                  DropdownMenuItem(value: 'NUMERO', child: Text('Número')),
                  DropdownMenuItem(value: 'DATA', child: Text('Data')),
                  DropdownMenuItem(value: 'CHECKBOX', child: Text('Checkbox')),
                  DropdownMenuItem(value: 'SELECT', child: Text('Seleção')),
                ],
                onChanged: (value) {
                  setState(() {
                    _tipoCampo = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Campo Obrigatório'),
                value: _isRequired,
                onChanged: (value) {
                  setState(() {
                    _isRequired = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _salvarCampo,
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

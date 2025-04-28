import 'package:flutter/material.dart';
import '../api/services/campo_service.dart';
import '../api/models/campo.dart';
import '../api/models/resposta.dart';

class AddCampoScreen extends StatefulWidget {
  final String formId;
  final CampoService campoService;

  const AddCampoScreen({
    super.key,
    required this.formId,
    required this.campoService,
  });

  @override
  State<AddCampoScreen> createState() => _AddCampoScreenState();
}

class _AddCampoScreenState extends State<AddCampoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  String _tipoCampo = 'TEXTO';
  bool _isRequired = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _salvarCampo() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final campo = Campo(
          campoId: '',
          titulo: _nomeController.text,
          tipo: _tipoCampo,
          resposta: Resposta(
            respostaId: '', // Added required parameter
            tipo: _tipoCampo,
            valor: '',
          ),
          isObrigatorio: _isRequired,
          descricao:
              _descricaoController.text.isNotEmpty
                  ? _descricaoController.text
                  : null,
        );

        await widget.campoService.adicionarCampo(
          // Changed to correct method name
          formId: widget.formId,
          campo: campo,
        );

        if (!mounted) return;

        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Campo adicionado com sucesso!')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar campo: ${e.toString()}')),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Campo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                        : const Text('Salvar Campo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

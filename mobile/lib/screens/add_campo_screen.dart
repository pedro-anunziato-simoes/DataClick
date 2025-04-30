import 'package:flutter/material.dart';
import '../api/services/campo_service.dart';

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
  final _tituloController = TextEditingController();
  String _tipoCampo = 'TEXTO';
  bool _isLoading = false;

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  Future<void> _salvarCampo() async {
    if (_tituloController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o título do campo')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final campoData = {
        'titulo': _tituloController.text,
        'tipo': _tipoCampo,
        'resposta': {'tipo': ''},
      };

      await widget.campoService.adicionarCampo(widget.formId, campoData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campo adicionado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar campo: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Campo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título do Campo',
                border: OutlineInputBorder(),
              ),
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
                DropdownMenuItem(value: 'EMAIL', child: Text('Email')),
              ],
              onChanged: (value) => setState(() => _tipoCampo = value!),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _salvarCampo,
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Adicionar Campo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

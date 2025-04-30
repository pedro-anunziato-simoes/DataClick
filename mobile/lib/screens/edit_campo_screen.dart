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
  late TextEditingController _tituloController;
  late String _tipoCampo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.campo.titulo);
    _tipoCampo = widget.campo.tipo;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  Future<void> _salvarCampo() async {
    setState(() => _isLoading = true);

    try {
      await widget.campoService.alterarCampo(
        campoId: widget.campo.campoId,
        tipo: _tipoCampo,
        titulo: _tituloController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campo atualizado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar campo: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Campo'),
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
                    onPressed: _isLoading ? null : _salvarCampo,
                    child:
                        _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Salvar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

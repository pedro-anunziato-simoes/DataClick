import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/api/repository/viewmodel/event_viewmodel.dart';
import 'package:mobile/api/models/evento.dart';
import 'package:intl/intl.dart';

class CriarEventoScreen extends StatefulWidget {
  const CriarEventoScreen({super.key});

  @override
  State<CriarEventoScreen> createState() => _CriarEventoScreenState();
}

class _CriarEventoScreenState extends State<CriarEventoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _localController = TextEditingController();
  DateTime? _dataInicio;
  DateTime? _dataFim;
  String _status = 'agendado';

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _localController.dispose();
    super.dispose();
  }

  Future<void> _selectData(BuildContext context, bool isDataInicio) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isDataInicio) {
          _dataInicio = picked;
        } else {
          _dataFim = picked;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _dataInicio != null &&
        _dataFim != null) {
      final eventViewModel = Provider.of<EventViewModel>(
        context,
        listen: false,
      );

      final novoEvento = Evento(
        id: '', // Será gerado pelo servidor
        nome: _nomeController.text,
        dataInicio: _dataInicio!,
        dataFim: _dataFim!,
        local: _localController.text,
        descricao: _descricaoController.text,
        formulariosAssociados: [],
        recrutadoresEnvolvidos: [],
        administradoresEnvolvidos: [],
        status: _status,
      );

      final sucesso = await eventViewModel.criarEvento(novoEvento);

      if (sucesso && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Evento criado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao criar evento.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF26A69A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        title: const Text('Criar Novo Evento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _localController,
                decoration: const InputDecoration(
                  labelText: 'Local',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um local';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                        _dataInicio == null
                            ? 'Selecione a data de início'
                            : 'Início: ${DateFormat('dd/MM/yyyy').format(_dataInicio!)}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectData(context, true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        _dataFim == null
                            ? 'Selecione a data de término'
                            : 'Término: ${DateFormat('dd/MM/yyyy').format(_dataFim!)}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectData(context, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items:
                    ['agendado', 'em andamento', 'finalizado']
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(
                              status[0].toUpperCase() + status.substring(1),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Criar Evento',
                  style: TextStyle(color: Color(0xFF26A69A), fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

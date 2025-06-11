import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/api/models/campo.dart';
import 'package:mobile/api/models/formulario.dart';
import 'package:mobile/api/services/formulario_service.dart';
import 'package:mobile/api/services/campo_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FillFormScreen extends StatefulWidget {
  final Formulario formulario;
  final FormularioService formularioService;
  final CampoService campoService;

  const FillFormScreen({
    Key? key,
    required this.formulario,
    required this.formularioService,
    required this.campoService,
  }) : super(key: key);

  @override
  State<FillFormScreen> createState() => _FillFormScreenState();
}

class _FillFormScreenState extends State<FillFormScreen> {
  final Map<String, dynamic> _respostas = {};
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, bool> _checkboxValues = {};
  final Map<String, String> _selectValues = {};
  DateTime? _selectedDate;

  // Máscaras para formatação
  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Validador de email
  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegExp.hasMatch(email);
  }

  // Formatter para email
  final _emailFormatter = TextInputFormatter.withFunction((oldValue, newValue) {
    // Converte para minúsculas
    final text = newValue.text.toLowerCase();
    // Remove espaços
    final withoutSpaces = text.replaceAll(' ', '');
    return TextEditingValue(
      text: withoutSpaces,
      selection: TextSelection.collapsed(offset: withoutSpaces.length),
    );
  });

  @override
  void initState() {
    super.initState();
    for (var campo in widget.formulario.campos) {
      if (campo.tipo == 'TEXTO' || campo.tipo == 'NUMERO' || campo.tipo == 'EMAIL') {
        _textControllers[campo.campoId] = TextEditingController();
      } else if (campo.tipo == 'CHECKBOX') {
        _checkboxValues[campo.campoId] = false;
      } else if (campo.tipo == 'SELECT') {
        _selectValues[campo.campoId] = '';
      }
    }
  }

  @override
  void dispose() {
    _textControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, String campoId) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _respostas[campoId] = picked.toIso8601String();
      });
    }
  }

  Widget _buildCampoInput(Campo campo) {
    switch (campo.tipo) {
      case 'TEXTO':
        return TextFormField(
          controller: _textControllers[campo.campoId],
          decoration: InputDecoration(
            labelText: campo.titulo,
            border: const OutlineInputBorder(),
          ),
        );

      case 'NUMERO':
        return TextFormField(
          controller: _textControllers[campo.campoId],
          decoration: InputDecoration(
            labelText: campo.titulo,
            border: const OutlineInputBorder(),
            hintText: '(00) 00000-0000',
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [_telefoneMask],
        );

      case 'EMAIL':
        return TextFormField(
          controller: _textControllers[campo.campoId],
          decoration: InputDecoration(
            labelText: campo.titulo,
            border: const OutlineInputBorder(),
            hintText: 'exemplo@email.com',
            errorText: _textControllers[campo.campoId]?.text.isNotEmpty == true &&
                    !_isValidEmail(_textControllers[campo.campoId]!.text)
                ? 'Email inválido'
                : null,
          ),
          keyboardType: TextInputType.emailAddress,
          inputFormatters: [_emailFormatter],
          autocorrect: false,
          enableSuggestions: false,
          onChanged: (value) {
            setState(() {}); // Atualiza o estado para mostrar/ocultar mensagem de erro
          },
        );

      case 'DATA':
        return InkWell(
          onTap: () => _selectDate(context, campo.campoId),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: campo.titulo,
              border: const OutlineInputBorder(),
            ),
            child: Text(
              _respostas[campo.campoId] != null
                  ? DateTime.parse(_respostas[campo.campoId]).toString().split(' ')[0]
                  : 'Selecione uma data',
            ),
          ),
        );

      case 'CHECKBOX':
        return CheckboxListTile(
          title: Text(campo.titulo),
          value: _checkboxValues[campo.campoId] ?? false,
          onChanged: (bool? value) {
            setState(() {
              _checkboxValues[campo.campoId] = value ?? false;
              _respostas[campo.campoId] = value.toString();
            });
          },
        );

      case 'SELECT':
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: campo.titulo,
            border: const OutlineInputBorder(),
          ),
          value: _selectValues[campo.campoId]?.isEmpty ?? true ? null : _selectValues[campo.campoId],
          items: campo.resposta?['opcoes'] != null
              ? List<String>.from(campo.resposta!['opcoes'])
                  .map((opcao) => DropdownMenuItem(
                        value: opcao,
                        child: Text(opcao),
                      ))
                  .toList()
              : [],
          onChanged: (String? value) {
            setState(() {
              _selectValues[campo.campoId] = value ?? '';
              _respostas[campo.campoId] = value;
            });
          },
        );

      default:
        return TextFormField(
          controller: _textControllers[campo.campoId],
          decoration: InputDecoration(
            labelText: campo.titulo,
            border: const OutlineInputBorder(),
          ),
        );
    }
  }

  void _submitForm() async {
    // Validar emails antes de enviar
    bool hasInvalidEmail = false;
    _textControllers.forEach((campoId, controller) {
      final campo = widget.formulario.campos.firstWhere(
        (c) => c.campoId == campoId,
        orElse: () => Campo(
          campoId: '', 
          titulo: '', 
          tipo: '',
          resposta: null,
        ),
      );
      
      if (campo.tipo == 'EMAIL' && !_isValidEmail(controller.text)) {
        hasInvalidEmail = true;
      }
    });

    if (hasInvalidEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, corrija os emails inválidos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Coletar respostas dos campos de texto
    _textControllers.forEach((campoId, controller) {
      _respostas[campoId] = controller.text;
    });

    // Coletar respostas dos checkboxes
    _checkboxValues.forEach((campoId, value) {
      _respostas[campoId] = value.toString();
    });

    // Coletar respostas dos selects
    _selectValues.forEach((campoId, value) {
      _respostas[campoId] = value;
    });

    print('Respostas do formulário: $_respostas');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dados coletados'),
        duration: Duration(seconds: 3),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formulario.formularioTitulo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              widget.formulario.descricao ?? '',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            ...widget.formulario.campos.map((campo) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildCampoInput(campo),
              );
            }).toList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Enviar Respostas'),
            ),
          ],
        ),
      ),
    );
  }
}

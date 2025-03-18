import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CreateFormScreen extends StatefulWidget {
  const CreateFormScreen({super.key});

  @override
  State<CreateFormScreen> createState() => _CreateFormScreenState();
}

class _CreateFormScreenState extends State<CreateFormScreen> {
  final List<Map<String, dynamic>> formFields = [];
  final TextEditingController _fieldTitleController = TextEditingController();
  final TextEditingController _optionController = TextEditingController();
  bool _isFieldRequired = false;
  String _selectedFieldType = 'text';
  final List<String> _options = [];

  void _addField() {
    if (_fieldTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira um título para o campo')),
      );
      return;
    }

    setState(() {
      formFields.add({
        'type': _selectedFieldType,
        'title': _fieldTitleController.text,
        'isRequired': _isFieldRequired,
        'options': (_selectedFieldType == 'select' || _selectedFieldType == 'checkbox')
            ? List<String>.from(_options)
            : <String>[],
      });
      
      _fieldTitleController.clear();
      _optionController.clear();
      _isFieldRequired = false;
      _options.clear();
    });
  }

  void removeField(int index) => setState(() => formFields.removeAt(index));

  void _addOption() {
    if (_optionController.text.isEmpty) return;
    
    setState(() => _options.add(_optionController.text));
    _optionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF26A69A),
      appBar: AppBar(
        title: const Text('Criar Formulário'),
        backgroundColor: const Color(0xFF26A69A),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: _buildFieldCreationSection(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: _buildFormPreview(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldCreationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xfbfffafb),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              controller: _fieldTitleController,
              decoration: _inputDecoration('Título do Campo', 'Ex: Nome Completo'),
            ),
          ),
          const SizedBox(height: 10),
          _buildTypeSelector(),
          if (_selectedFieldType == 'select' || _selectedFieldType == 'checkbox') 
            _buildOptionAdder(),
          const SizedBox(height: 10),
          _buildRequiredCheckbox(),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addField,
            child: const Text('Adicionar Campo'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormPreview() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xfbfffafb),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 78.68,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E2C2F),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(14)),
                  ),
                  child: const Center(
                    child: Text(
                      "Formulário",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                      itemCount: formFields.length,
                      itemBuilder: (context, index) {
                        final field = formFields[index];
                        return _buildPreviewField(
                          label: field['title'] as String,
                          isRequired: field['isRequired'] as bool,
                          type: field['type'] as String,
                          options: field['options'] as List<String>,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: GestureDetector(
                onTap: saveForm,
                child: Container(
                  width: 99.43,
                  height: 29.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xfffffafb), Color(0xff7de2d1)],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Salvar",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewField({
    required String label,
    required bool isRequired,
    required String type,
    required List<String> options,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        if (type == 'text')
          Container(
            width: 276.07,
            height: 37.19,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
        if (type == 'checkbox')
          Column(
            children: options.map((option) {
              return CheckboxListTile(
                title: Text(option),
                value: false,
                onChanged: (bool? value) {},
                controlAffinity: ListTileControlAffinity.leading,
              );
            }).toList(),
          ),
        if (type == 'select')
          DropdownButtonFormField<String>(
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (value) {},
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      color: Colors.white,
      child: DropdownButton<String>(
        value: _selectedFieldType,
        onChanged: (value) => setState(() => _selectedFieldType = value!),
        items: const [
          DropdownMenuItem(value: 'text', child: Text('Texto')),
          DropdownMenuItem(value: 'select', child: Text('Seleção')),
          DropdownMenuItem(value: 'checkbox', child: Text('Checkbox')),
        ],
      ),
    );
  }

  Widget _buildOptionAdder() {
    return Column(
      children: [
        SizedBox(
          width: 300,
          child: TextField(
            controller: _optionController,
            decoration: _inputDecoration('Adicionar Opção', 'Ex: Opção 1'),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addOption,
          child: const Text('Adicionar Opção'),
        ),
        const SizedBox(height: 10),
        Text(
          'Opções: ${_options.join(", ")}',
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildRequiredCheckbox() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Checkbox(
            value: _isFieldRequired,
            onChanged: (value) => setState(() => _isFieldRequired = value!),
          ),
          const Text('Campo Obrigatório'),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
    );
  }

  void saveForm() {
    if (formFields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos um campo')),
      );
      return;
    }

    if (kDebugMode) print('Formulário Salvo: $formFields');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulário salvo com sucesso!')),
    );
    
    setState(() => formFields.clear());
  }
}
import 'package:flutter/material.dart';
import 'package:mobile/api/models/formulario.dart';
import 'package:provider/provider.dart';
import 'package:mobile/api/repository/viewmodel/forms_viewmodel.dart' as forms_vm;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';

class PreencherFormularioScreen extends StatefulWidget {
  final Formulario formulario;

  const PreencherFormularioScreen({
    super.key,
    required this.formulario,
  });

  @override
  State<PreencherFormularioScreen> createState() => _PreencherFormularioScreenState();
}

class _PreencherFormularioScreenState extends State<PreencherFormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _respostas = {};

  // Input masks
  final _phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _dateMask = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF26A69A), Color(0xFF00796B)],
            ),
          ),
        ),
        title: Text(
          widget.formulario.titulo ?? 'Formulário',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (widget.formulario.descricao != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.formulario.descricao!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    ...widget.formulario.campos?.map((campo) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildCampoFormulario(campo, theme),
                      );
                    }).toList() ?? [],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: FilledButton.icon(
                  onPressed: _salvarFormulario,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Salvar Respostas'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF26A69A),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampoFormulario(dynamic campo, ThemeData theme) {
    final campoTitulo = campo.titulo;
    final campoTipo = campo.tipo;
    final campoId = campo.campoId;

    // Determine if the field should use a specific mask based on its title
    final lowerTitle = campoTitulo.toLowerCase();
    if (lowerTitle.contains('telefone') || lowerTitle.contains('celular') || lowerTitle.contains('fone')) {
      return _buildCampoTelefone(campoTitulo, campoId);
    } else if (lowerTitle.contains('cpf')) {
      return _buildCampoCPF(campoTitulo, campoId);
    } else if (lowerTitle.contains('cnpj')) {
      return _buildCampoCNPJ(campoTitulo, campoId);
    }

    switch (campoTipo.toUpperCase()) {
      case 'TEXTO':
        return _buildCampoTexto(campoTitulo, campoId);
      case 'NUMERO':
        return _buildCampoNumero(campoTitulo, campoId);
      case 'EMAIL':
        return _buildCampoEmail(campoTitulo, campoId);
      case 'DATA':
        return _buildCampoData(campoTitulo, campoId);
      case 'CHECKBOX':
        return _buildCampoCheckbox(campoTitulo, campoId);
      default:
        return _buildCampoTexto(campoTitulo, campoId);
    }
  }

  Widget _buildCampoTexto(String titulo, String campoId) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: titulo,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, preencha este campo';
        }
        return null;
      },
      onSaved: (value) {
        _respostas[campoId] = value;
      },
    );
  }

  Widget _buildCampoTelefone(String titulo, String campoId) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: titulo,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [_phoneMask],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, preencha este campo';
        }
        if (value.replaceAll(RegExp(r'[^0-9]'), '').length < 10) {
          return 'Por favor, insira um número válido';
        }
        return null;
      },
      onSaved: (value) {
        _respostas[campoId] = value;
      },
    );
  }

  Widget _buildCampoCPF(String titulo, String campoId) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: titulo,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.badge),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [_cpfMask],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, preencha este campo';
        }
        if (value.replaceAll(RegExp(r'[^0-9]'), '').length != 11) {
          return 'CPF inválido';
        }
        return null;
      },
      onSaved: (value) {
        _respostas[campoId] = value;
      },
    );
  }

  Widget _buildCampoCNPJ(String titulo, String campoId) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: titulo,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.business),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [_cnpjMask],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, preencha este campo';
        }
        if (value.replaceAll(RegExp(r'[^0-9]'), '').length != 14) {
          return 'CNPJ inválido';
        }
        return null;
      },
      onSaved: (value) {
        _respostas[campoId] = value;
      },
    );
  }

  Widget _buildCampoNumero(String titulo, String campoId) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: titulo,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.numbers),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, preencha este campo';
        }
        if (double.tryParse(value) == null) {
          return 'Por favor, insira um número válido';
        }
        return null;
      },
      onSaved: (value) {
        _respostas[campoId] = double.tryParse(value ?? '0') ?? 0;
      },
    );
  }

  Widget _buildCampoEmail(String titulo, String campoId) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: titulo,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, preencha este campo';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Por favor, insira um email válido';
        }
        return null;
      },
      onSaved: (value) {
        _respostas[campoId] = value;
      },
    );
  }

  Widget _buildCampoData(String titulo, String campoId) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: titulo,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.calendar_today),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [_dateMask],
      readOnly: true,
      onTap: () async {
        final data = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (data != null) {
          setState(() {
            _respostas[campoId] = data.toIso8601String();
          });
        }
      },
      validator: (value) {
        if (_respostas[campoId] == null) {
          return 'Por favor, selecione uma data';
        }
        return null;
      },
    );
  }

  Widget _buildCampoCheckbox(String titulo, String campoId) {
    return StatefulBuilder(
      builder: (context, setState) {
        return CheckboxListTile(
          title: Text(titulo),
          value: _respostas[campoId] ?? false,
          onChanged: (value) {
            setState(() {
              _respostas[campoId] = value;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          tileColor: Colors.white,
          activeColor: const Color(0xFF26A69A),
        );
      },
    );
  }

  void _salvarFormulario() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      
      // TODO: Implementar a lógica de salvamento das respostas
      print('Debug - Respostas do formulário: $_respostas');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Formulário salvo com sucesso!'),
            ],
          ),
          backgroundColor: Color(0xFF26A69A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
      
      Navigator.pop(context);
    }
  }
} 
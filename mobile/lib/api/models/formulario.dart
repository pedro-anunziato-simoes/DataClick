import 'package:flutter/foundation.dart';
import 'campo.dart';

class Formulario {
  final String id;
  final String formularioTitulo;
  final String formAdminId;
  final List<Campo> campos;
  final String? descricao;
  final DateTime? dataCriacao;
  final String? formularioEventoId;

  Formulario({
    required this.id,
    required this.formularioTitulo,
    required this.formAdminId,
    required this.campos,
    this.descricao,
    this.dataCriacao,
    this.formularioEventoId,
  });

  factory Formulario.fromJson(Map<String, dynamic> json) {
    // debugPrint('DEBUG: JSON recebido em Formulario.fromJson: $json');
    // debugPrint('DEBUG: Título do formulário enviado: ${json['titulo']}');
    // debugPrint('DEBUG: FormularioTitulo do backend: ${json['formularioTitulo']}');

    try {
      List<Campo> campos = [];
      if (json['campos'] != null && json['campos'] is List) {
        campos =
            (json['campos'] as List)
                .map((e) => Campo.fromJson(e ?? {}))
                .toList();
      }

      // Try multiple possible title field names
      String titulo =
          json['titulo']?.toString() ??
          json['formularioTitulo']?.toString() ??
          json['formTitulo']?.toString() ??
          'Sem título';

      return Formulario(
        id: json['id']?.toString() ?? json['formId']?.toString() ?? '',
        titulo: titulo,
        adminId:
        id: json['id']?.toString() ?? '',
        formularioTitulo: json['formularioTitulo']?.toString() ?? 'Sem título',
        formAdminId:
            json['adminId']?.toString() ??
            json['formAdminId']?.toString() ??
            '',
        campos: campos,
        descricao: json['descricao']?.toString(),
        dataCriacao:
            json['dataCriacao'] != null
                ? DateTime.tryParse(json['dataCriacao'])
                : null,
        eventoId:
            json['eventoId']?.toString() ??
            json['formularioEventoId']?.toString(),
        formularioEventoId: json['eventoId']?.toString(),
      );
    } catch (e) {
      // debugPrint('Erro ao parsear Formulario: $e');
      return Formulario(
        id: '',
        formularioTitulo: 'Erro ao carregar',
        formAdminId: '',
        campos: [],
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'formularioTitulo': formularioTitulo,
    'formAdminId': formAdminId,
    'campos': campos.map((e) => e.toJson()).toList(),
    if (descricao != null) 'descricao': descricao,
    if (dataCriacao != null) 'dataCriacao': dataCriacao!.toIso8601String(),
    if (formularioEventoId != null) 'eventoId': formularioEventoId,
  };

  @override
  String toString() {
    return 'Formulario{id: $id, titulo: $titulo, adminId: $adminId, campos: ${campos.length}, descricao: $descricao}';
  }

  copyWith({required String id, required String titulo}) {}
}

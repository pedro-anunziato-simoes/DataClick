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
    try {
      List<Campo> campos = [];
      if (json['campos'] != null && json['campos'] is List) {
        campos =
            (json['campos'] as List)
                .map((e) => Campo.fromJson(e ?? {}))
                .toList();
      }

      return Formulario(
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
        formularioEventoId: json['eventoId']?.toString(),
      );
    } catch (e) {
      debugPrint('Erro ao parsear Formulario: $e');
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

  copyWith({required String id, required String titulo}) {}
}

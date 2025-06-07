import 'package:flutter/foundation.dart';
import 'campo.dart';

class Formulario {
  final String id;
  final String titulo;
  final String adminId;
  final List<Campo> campos;
  final String? descricao;
  final DateTime? dataCriacao;
  final String? eventoId;

  Formulario({
    required this.id,
    required this.titulo,
    required this.adminId,
    required this.campos,
    this.descricao,
    this.dataCriacao,
    this.eventoId,
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
        titulo: json['titulo']?.toString() ?? 'Sem título',
        adminId:
            json['adminId']?.toString() ??
            json['formAdminId']?.toString() ??
            '',
        campos: campos,
        descricao: json['descricao']?.toString(),
        dataCriacao:
            json['dataCriacao'] != null
                ? DateTime.tryParse(json['dataCriacao'])
                : null,
        eventoId: json['eventoId']?.toString(),
      );
    } catch (e) {
      debugPrint('Erro ao parsear Formulario: $e');
      return Formulario(
        id: '',
        titulo: 'Erro ao carregar',
        adminId: '',
        campos: [],
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'adminId': adminId,
    'campos': campos.map((e) => e.toJson()).toList(),
    if (descricao != null) 'descricao': descricao,
    if (dataCriacao != null) 'dataCriacao': dataCriacao!.toIso8601String(),
    if (eventoId != null) 'eventoId': eventoId,
  };

  copyWith({required String id, required String titulo}) {}
}

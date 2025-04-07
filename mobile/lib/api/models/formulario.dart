import 'campo.dart';

class Formulario {
  final String formId;
  final String titulo;
  final String adminId;
  final List<Campo> campos;
  final String id;
  final String? descricao;
  final DateTime? dataCriacao;

  Formulario({
    required this.formId,
    required this.titulo,
    required this.adminId,
    required this.campos,
    required this.id,
    this.descricao,
    this.dataCriacao,
  });

  factory Formulario.fromJson(Map<String, dynamic> json) {
    return Formulario(
      formId: json['formId'] ?? '',
      titulo: json['titulo'] ?? '',
      adminId: json['adminId'] ?? '',
      campos:
          (json['campos'] as List<dynamic>?)
              ?.map((e) => Campo.fromJson(e))
              .toList() ??
          [],
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formId': formId,
      'titulo': titulo,
      'adminId': adminId,
      'campos': campos.map((e) => e.toJson()).toList(),
      'id': id,
    };
  }
}

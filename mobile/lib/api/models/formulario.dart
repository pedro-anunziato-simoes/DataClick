import 'campo.dart';

class Formulario {
  final String id;
  final String formId;
  final String titulo;
  final String adminId;
  final List<Campo> campos;
  final String? descricao;
  final DateTime? dataCriacao;

  Formulario({
    required this.id,
    required this.formId,
    required this.titulo,
    required this.adminId,
    required this.campos,
    this.descricao,
    this.dataCriacao,
  });

  factory Formulario.fromJson(Map<String, dynamic> json) {
    return Formulario(
      id: json['id'] ?? json['formId'] ?? '',

      formId: json['formId'] ?? '',

      titulo: json['titulo'] ?? json['tituloForm'] ?? 'Sem título',
      adminId: json['adminId'] ?? '',
      campos:
          (json['campos'] as List<dynamic>?)
              ?.map((e) => Campo.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formId': formId,
      'titulo': titulo,
      'adminId': adminId,
      'campos': campos.map((e) => e.toJson()).toList(),
      // Inclua apenas se os campos não forem nulos
      if (descricao != null) 'descricao': descricao,
      if (dataCriacao != null) 'dataCriacao': dataCriacao!.toIso8601String(),
    };
  }
}

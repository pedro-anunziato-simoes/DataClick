import 'campo.dart';

class Formulario {
  final String id;
  final String titulo;
  final String adminId;
  final List<Campo> campos;

  Formulario({
    required this.id,
    required this.titulo,
    required this.adminId,
    required this.campos,
  });

  factory Formulario.fromJson(Map<String, dynamic> json) {
    return Formulario(
      id: json['id'],
      titulo: json['titulo'],
      adminId: json['adminId'],
      campos: (json['campos'] as List).map((e) => Campo.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'adminId': adminId,
      'campos': campos.map((e) => e.toJson()).toList(),
    };
  }
}

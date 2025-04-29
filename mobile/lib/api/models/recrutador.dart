import 'formulario.dart';

class Recrutador {
  final String usuarioId;
  final String nome;
  final String telefone;
  final String email;
  final String adminId;
  final List<Formulario> formularios;

  Recrutador({
    required this.usuarioId,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.adminId,
    required this.formularios,
  });

  factory Recrutador.fromJson(Map<String, dynamic> json) {
    return Recrutador(
      usuarioId: json['usuarioId'] ?? '',
      nome: json['nome'] ?? '',
      telefone: json['telefone'] ?? '',
      email: json['email'] ?? '',
      adminId: json['adminId'] ?? '',
      formularios:
          (json['formularios'] as List<dynamic>?)
              ?.map((e) => Formulario.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuarioId': usuarioId,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'adminId': adminId,
      'formularios': formularios.map((e) => e.toJson()).toList(),
    };
  }

  Recrutador copyWith({
    String? usuarioId,
    String? nome,
    String? telefone,
    String? email,
    String? adminId,
    List<Formulario>? formularios,
  }) {
    return Recrutador(
      usuarioId: usuarioId ?? this.usuarioId,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      adminId: adminId ?? this.adminId,
      formularios: formularios ?? this.formularios,
    );
  }
}

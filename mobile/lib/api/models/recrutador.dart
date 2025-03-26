import 'formulario.dart';

class Recrutador {
  final String id;
  final String nome;
  final String telefone;
  final String senha;
  final String email;
  final String adminId;
  final List<Formulario> formularios;

  Recrutador({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.senha,
    required this.email,
    required this.adminId,
    required this.formularios,
  });

  factory Recrutador.fromJson(Map<String, dynamic> json) {
    return Recrutador(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
      senha: json['senha'],
      email: json['email'],
      adminId: json['adminId'],
      formularios:
          (json['formularios'] as List)
              .map((e) => Formulario.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'senha': senha,
      'email': email,
      'adminId': adminId,
      'formularios': formularios.map((form) => form.toJson()).toList(),
    };
  }
}

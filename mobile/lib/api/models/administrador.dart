import 'recrutador.dart';
import 'formulario.dart';

class Administrador {
  final String usuarioId;
  final String nome;
  final String telefone;
  final String email;
  final String cnpj;
  final String senha;
  final List<Recrutador> recrutadores;
  final List<Formulario> formularios;

  Administrador({
    required this.usuarioId,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.cnpj,
    required this.senha,
    required this.recrutadores,
    required this.formularios,
  });

  factory Administrador.fromJson(Map<String, dynamic> json) {
    return Administrador(
      usuarioId: json['usuarioId'] ?? '',
      nome: json['nome'] ?? '',
      telefone: json['telefone'] ?? '',
      email: json['email'] ?? '',
      cnpj: json['cnpj'] ?? '',
      senha: json['senha'] ?? '',
      recrutadores:
          (json['recrutadores'] as List<dynamic>?)
              ?.map((e) => Recrutador.fromJson(e))
              .toList() ??
          [],
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
      'cnpj': cnpj,
      'senha': senha,
      'recrutadores': recrutadores.map((e) => e.toJson()).toList(),
      'formularios': formularios.map((e) => e.toJson()).toList(),
    };
  }
}

import 'recrutador.dart';
import 'formulario.dart';

class Administrador {
  final String id;
  final String nome;
  final String telefone;
  final String senha;
  final String email;
  final String cnpj;
  final List<Recrutador> recrutadores;
  final List<Formulario> formularios;

  Administrador({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.senha,
    required this.email,
    required this.cnpj,
    required this.recrutadores,
    required this.formularios,
  });

  factory Administrador.fromJson(Map<String, dynamic> json) {
    return Administrador(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
      senha: json['senha'],
      email: json['email'],
      cnpj: json['cnpj'],
      recrutadores:
          (json['recrutadores'] as List)
              .map((e) => Recrutador.fromJson(e))
              .toList(),
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
      'cnpj': cnpj,
      'recrutadores': recrutadores.map((e) => e.toJson()).toList(),
      'formularios': formularios.map((e) => e.toJson()).toList(),
    };
  }
}

import 'evento.dart';
import 'formulario.dart';
import 'recrutador.dart';

class Administrador {
  final String usuarioId;
  final String nome;
  final String telefone;
  final String email;
  final String cnpj;
  final String? senha;
  final String? token;
  final List<Recrutador>? adminRecrutadores;
  final List<Formulario>? adminFormularios;
  final List<Evento>? adminEventos;
  final List<dynamic>? adminFormsPreenchidos;

  Administrador({
    required this.usuarioId,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.cnpj,
    this.senha,
    this.token,
    this.adminRecrutadores,
    this.adminFormularios,
    this.adminEventos,
    this.adminFormsPreenchidos,
  });

  factory Administrador.fromJson(Map<String, dynamic> json) {
    return Administrador(
      usuarioId: json['usuarioId'] ?? json['id'] ?? '',
      nome: json['nome'] ?? '',
      telefone: json['telefone'] ?? '',
      email: json['email'] ?? '',
      cnpj: json['cnpj'] ?? '',
      senha: json['senha'],
      token: json['token'],
      adminRecrutadores:
          (json['adminRecrutadores'] as List<dynamic>?)
              ?.map((e) => Recrutador.fromJson(e as Map<String, dynamic>))
              .toList(),
      adminFormularios:
          (json['adminFormularios'] as List<dynamic>?)
              ?.map((e) => Formulario.fromJson(e as Map<String, dynamic>))
              .toList(),
      adminEventos:
          (json['adminEventos'] as List<dynamic>?)
              ?.map((e) => Evento.fromJson(e as Map<String, dynamic>))
              .toList(),
      adminFormsPreenchidos: json['adminFormsPreenchidos'] as List<dynamic>?,
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
      'token': token,
      if (adminRecrutadores != null)
        'adminRecrutadores': adminRecrutadores!.map((e) => e.toJson()).toList(),
      if (adminFormularios != null)
        'adminFormularios': adminFormularios!.map((e) => e.toJson()).toList(),
      if (adminEventos != null)
        'adminEventos': adminEventos!.map((e) => e.toJson()).toList(),
      if (adminFormsPreenchidos != null)
        'adminFormsPreenchidos': adminFormsPreenchidos,
    };
  }

  Administrador copyWith({
    String? usuarioId,
    String? nome,
    String? telefone,
    String? email,
    String? cnpj,
    String? senha,
    String? token,
    List<Recrutador>? adminRecrutadores,
    List<Formulario>? adminFormularios,
    List<Evento>? adminEventos,
    List<dynamic>? adminFormsPreenchidos,
  }) {
    return Administrador(
      usuarioId: usuarioId ?? this.usuarioId,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      cnpj: cnpj ?? this.cnpj,
      senha: senha ?? this.senha,
      token: token ?? this.token,
      adminRecrutadores: adminRecrutadores ?? this.adminRecrutadores,
      adminFormularios: adminFormularios ?? this.adminFormularios,
      adminEventos: adminEventos ?? this.adminEventos,
      adminFormsPreenchidos:
          adminFormsPreenchidos ?? this.adminFormsPreenchidos,
    );
  }

  @override
  String toString() {
    return 'Administrador{usuarioId: $usuarioId, nome: $nome, email: $email, cnpj: $cnpj}';
  }
}

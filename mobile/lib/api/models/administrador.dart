import 'evento.dart';
import 'formulario.dart';
import 'recrutador.dart';

class Administrador {
  final String usuarioId;
  final String nome;
  final String telefone;
  final String email;
  final String? senha;
  final String? token;
  final List<Recrutador>? recrutadores;
  final List<Formulario>? formularios;
  final List<Evento>? eventos;

  Administrador({
    required this.usuarioId,
    required this.nome,
    required this.telefone,
    required this.email,
    this.senha,
    this.token,
    this.recrutadores,
    this.formularios,
    this.eventos,
  });

  factory Administrador.fromJson(Map<String, dynamic> json) {
    return Administrador(
      usuarioId: json['usuarioId'] ?? '',
      nome: json['nome'] ?? '',
      telefone: json['telefone'] ?? '',
      email: json['email'] ?? '',
      senha: json['senha'],
      token: json['token'],
      recrutadores:
          (json['recrutadores'] as List<dynamic>?)
              ?.map((e) => Recrutador.fromJson(e as Map<String, dynamic>))
              .toList(),
      formularios:
          (json['formularios'] as List<dynamic>?)
              ?.map((e) => Formulario.fromJson(e as Map<String, dynamic>))
              .toList(),
      eventos:
          (json['eventos'] as List<dynamic>?)
              ?.map((e) => Evento.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuarioId': usuarioId,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'senha': senha,
      'token': token,
      if (recrutadores != null)
        'recrutadores': recrutadores!.map((e) => e.toJson()).toList(),
      if (formularios != null)
        'formularios': formularios!.map((e) => e.toJson()).toList(),
      if (eventos != null) 'eventos': eventos!.map((e) => e.toJson()).toList(),
    };
  }

  Administrador copyWith({
    String? usuarioId,
    String? nome,
    String? telefone,
    String? email,
    String? senha,
    String? token,
    List<Recrutador>? recrutadores,
    List<Formulario>? formularios,
    List<Evento>? eventos,
  }) {
    return Administrador(
      usuarioId: usuarioId ?? this.usuarioId,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      token: token ?? this.token,
      recrutadores: recrutadores ?? this.recrutadores,
      formularios: formularios ?? this.formularios,
      eventos: eventos ?? this.eventos,
    );
  }
}

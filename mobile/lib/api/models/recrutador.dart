import 'evento.dart' as evento;
import 'formulario.dart';

class Recrutador {
  final String? usuarioId;
  final String? adminId;
  final String nome;
  final String telefone;
  final String email;
  final String senha;
  final String? token;
  final List<Formulario>? formularios;
  final List<evento.Evento>? eventos;

  Recrutador({
    this.usuarioId,
    this.adminId,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.senha,
    this.token,
    this.formularios,
    this.eventos,
  });

  factory Recrutador.fromJson(Map<String, dynamic> json) {
    return Recrutador(
      usuarioId: json['usuarioId'] as String? ?? json['id'] as String?,
      adminId: json['adminId'] as String?,
      nome: json['nome'] as String? ?? '',
      telefone: json['telefone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      senha: json['senha'] as String? ?? '',
      token: json['token'] as String?,
      formularios:
          (json['formularios'] as List<dynamic>?)
              ?.map((e) => Formulario.fromJson(e as Map<String, dynamic>))
              .toList(),
      eventos:
          (json['eventos'] as List<dynamic>?)
              ?.map((e) => evento.Evento.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'senha': senha,
    };

    if (usuarioId != null) data['usuarioId'] = usuarioId;
    if (adminId != null) data['adminId'] = adminId;
    if (token != null) data['token'] = token;
    if (formularios != null) {
      data['formularios'] = formularios!.map((e) => e.toJson()).toList();
    }
    if (eventos != null) {
      data['eventos'] = eventos!.map((e) => e.toJson()).toList();
    }

    return data;
  }

  Recrutador copyWith({
    String? usuarioId,
    String? adminId,
    String? nome,
    String? telefone,
    String? email,
    String? senha,
    String? token,
    List<Formulario>? formularios,
    List<evento.Evento>? eventos,
  }) {
    return Recrutador(
      usuarioId: usuarioId ?? this.usuarioId,
      adminId: adminId ?? this.adminId,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      token: token ?? this.token,
      formularios: formularios ?? this.formularios,
      eventos: eventos ?? this.eventos,
    );
  }
}

class RecrutadorCreateDTO {
  final String nome;
  final String telefone;
  final String email;
  final String senha;
  final String adminId;

  RecrutadorCreateDTO({
    required this.nome,
    required this.telefone,
    required this.email,
    required this.senha,
    required this.adminId,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'senha': senha,
      'adminId': adminId,
    };
  }
}

class RecrutadorUpdateDTO {
  final String? nome;
  final String? telefone;
  final String? email;
  final String? senha;

  RecrutadorUpdateDTO({this.nome, this.telefone, this.email, this.senha});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (nome != null) data['nome'] = nome;
    if (telefone != null) data['telefone'] = telefone;
    if (email != null) data['email'] = email;
    if (senha != null) data['senha'] = senha;

    return data;
  }
}

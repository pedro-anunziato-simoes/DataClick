import 'evento.dart';

class Recrutador {
  final String? usuarioId;
  final String? adminId;
  final String nome;
  final String telefone;
  final String email;
  final String senha;
  final List<Evento>? formularios;
  final List<Evento>? eventos;

  Recrutador({
    this.usuarioId,
    this.adminId,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.senha,
    this.formularios,
    this.eventos,
  });

  factory Recrutador.fromJson(Map<String, dynamic> json) {
    return Recrutador(
      usuarioId: json['usuarioId'] as String? ?? json['id'] as String?,
      adminId: json['adminId'] as String?,
      nome: json['nome'] as String,
      telefone: json['telefone'] as String,
      email: json['email'] as String,
      senha: json['senha'] as String,
      formularios:
          (json['formularios'] as List<dynamic>?)
              ?.map((e) => Evento.fromJson(e as Map<String, dynamic>))
              .toList(),
      eventos:
          (json['eventos'] as List<dynamic>?)
              ?.map((e) => Evento.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (usuarioId != null) 'usuarioId': usuarioId,
      if (adminId != null) 'adminId': adminId,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'senha': senha,
      if (formularios != null)
        'formularios': formularios?.map((e) => e.toJson()).toList(),
      if (eventos != null) 'eventos': eventos?.map((e) => e.toJson()).toList(),
    };
  }

  Recrutador copyWith({
    String? usuarioId,
    String? adminId,
    String? nome,
    String? telefone,
    String? email,
    String? senha,
    List<Evento>? formularios,
    List<Evento>? eventos,
  }) {
    return Recrutador(
      usuarioId: usuarioId ?? this.usuarioId,
      adminId: adminId ?? this.adminId,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      senha: senha ?? this.senha,
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

  RecrutadorCreateDTO({
    required this.nome,
    required this.telefone,
    required this.email,
    required this.senha,
  });

  Map<String, dynamic> toJson() {
    return {'nome': nome, 'telefone': telefone, 'email': email, 'senha': senha};
  }
}

class RecrutadorUpdateDTO {
  final String? nome;
  final String? telefone;
  final String? email;
  final String? senha;

  RecrutadorUpdateDTO({this.nome, this.telefone, this.email, this.senha});

  Map<String, dynamic> toJson() {
    return {
      if (nome != null) 'nome': nome,
      if (telefone != null) 'telefone': telefone,
      if (email != null) 'email': email,
      if (senha != null) 'senha': senha,
    };
  }
}

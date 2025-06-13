import 'evento.dart' as evento;
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
  final List<evento.Evento>? adminEventos;
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
    // Mapeia os campos principais
    final usuarioId = json['usuarioId'] ?? json['id'] ?? '';
    final nome = json['nome'] ?? '';
    final telefone = json['telefone'] ?? '';
    final email = json['email'] ?? '';
    final cnpj = json['cnpj'] ?? '';
    final senha = json['senha'] ?? json['password'];
    final token = json['token'];

    // Mapeia as listas
    List<Recrutador>? adminRecrutadores;
    if (json['adminRecrutadores'] != null) {
      try {
        adminRecrutadores =
            (json['adminRecrutadores'] as List<dynamic>)
                .map((e) => Recrutador.fromJson(e as Map<String, dynamic>))
                .toList();
      } catch (e) {
        adminRecrutadores = null;
      }
    }

    List<Formulario>? adminFormularios;
    if (json['adminFormularios'] != null) {
      try {
        adminFormularios =
            (json['adminFormularios'] as List<dynamic>)
                .map((e) => Formulario.fromJson(e as Map<String, dynamic>))
                .toList();
      } catch (e) {
        adminFormularios = null;
      }
    }

    List<evento.Evento>? adminEventos;
    if (json['adminEventos'] != null) {
      try {
        adminEventos =
            (json['adminEventos'] as List<dynamic>)
                .map((e) => evento.Evento.fromJson(e as Map<String, dynamic>))
                .toList();
      } catch (e) {
        adminEventos = null;
      }
    }

    List<dynamic>? adminFormsPreenchidos;
    if (json['adminFormsPreenchidos'] != null) {
      adminFormsPreenchidos = json['adminFormsPreenchidos'] as List<dynamic>;
    }

    return Administrador(
      usuarioId: usuarioId,
      nome: nome,
      telefone: telefone,
      email: email,
      cnpj: cnpj,
      senha: senha,
      token: token,
      adminRecrutadores: adminRecrutadores,
      adminFormularios: adminFormularios,
      adminEventos: adminEventos,
      adminFormsPreenchidos: adminFormsPreenchidos,
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
    List<evento.Evento>? adminEventos,
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

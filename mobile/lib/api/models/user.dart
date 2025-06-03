import 'administrador.dart';
import 'recrutador.dart';
import 'evento.dart';

enum UserRole { admin, recrutador, candidato }

class User {
  final String usuarioId;
  final String nome;
  final String email;
  final String? telefone;
  final String tipo;
  final String? senha;
  final String? adminId;
  final UserRole role;
  final List<Evento>? eventos;
  final String? token;

  User({
    required this.usuarioId,
    required this.nome,
    required this.email,
    this.telefone,
    required this.tipo,
    this.senha,
    this.adminId,
    required this.role,
    this.eventos,
    this.token,
  });

  factory User.fromAdmin(Administrador admin) {
    return User(
      usuarioId: admin.usuarioId,
      nome: admin.nome,
      email: admin.email,
      telefone: admin.telefone,
      tipo: 'admin',
      role: UserRole.admin,
      eventos: admin.eventos,
      token: admin.token,
    );
  }

  factory User.fromRecrutador(Recrutador recrutador) {
    return User(
      usuarioId: recrutador.usuarioId ?? '',
      nome: recrutador.nome,
      email: recrutador.email,
      telefone: recrutador.telefone,
      tipo: 'recrutador',
      adminId: recrutador.adminId,
      role: UserRole.recrutador,
      eventos: recrutador.eventos,
      token: recrutador.token,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    UserRole roleFromString(String? roleStr) {
      switch (roleStr?.toLowerCase()) {
        case 'admin':
          return UserRole.admin;
        case 'recrutador':
          return UserRole.recrutador;
        default:
          return UserRole.candidato;
      }
    }

    List<Evento>? eventosFromJson(List<dynamic>? eventosJson) {
      if (eventosJson == null) return null;
      return eventosJson.map((e) => Evento.fromJson(e)).toList();
    }

    return User(
      usuarioId: json['usuarioId'] ?? json['id'] ?? '',
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'],
      tipo: json['tipo'] ?? 'usuario',
      senha: json['senha'],
      adminId: json['adminId'],
      role: roleFromString(json['role']),
      eventos: eventosFromJson(json['eventos']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    String roleToString() {
      switch (role) {
        case UserRole.admin:
          return 'admin';
        case UserRole.recrutador:
          return 'recrutador';
        case UserRole.candidato:
          return 'candidato';
      }
    }

    return {
      'usuarioId': usuarioId,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'tipo': tipo,
      'senha': senha,
      'adminId': adminId,
      'role': roleToString(),
      'eventos': eventos?.map((e) => e.toJson()).toList(),
      'token': token,
    };
  }

  User copyWith({
    String? usuarioId,
    String? nome,
    String? email,
    String? telefone,
    String? tipo,
    String? senha,
    String? adminId,
    UserRole? role,
    List<Evento>? eventos,
    String? token,
  }) {
    return User(
      usuarioId: usuarioId ?? this.usuarioId,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      tipo: tipo ?? this.tipo,
      senha: senha ?? this.senha,
      adminId: adminId ?? this.adminId,
      role: role ?? this.role,
      eventos: eventos ?? this.eventos,
      token: token ?? this.token,
    );
  }

  bool hasAdminRole() => role == UserRole.admin;
  bool isAdmin() => role == UserRole.admin;
  bool isRecrutador() => role == UserRole.recrutador;
  bool isCandidato() => role == UserRole.candidato;

  @override
  String toString() {
    return 'User{usuarioId: $usuarioId, nome: $nome, email: $email, role: $role}';
  }
}

import 'administrador.dart';
import 'recrutador.dart';
import 'evento.dart';

enum UserRole { ADMIN, USER }

class User {
  final String usuarioId;
  final String? nome;
  final String? email;
  final String? telefone;
  final String tipo;
  final String? senha;
  final String? adminId;
  final UserRole role;
  final List<Evento>? eventos;
  final String? token;

  User({
    required this.usuarioId,
    this.nome,
    this.email,
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
      role: UserRole.ADMIN,
      eventos: admin.eventos,
      token: null,
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
      role: UserRole.USER,
      eventos: recrutador.eventos,
      token: null,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    UserRole roleFromString(String? roleStr) {
      if (roleStr == 'ADMIN' || roleStr == 'ROLE_ADMIN') {
        return UserRole.ADMIN;
      }
      return UserRole.USER;
    }

    List<Evento>? eventosFromJson(List<dynamic>? eventosJson) {
      if (eventosJson == null) return null;
      return eventosJson.map((e) => Evento.fromJson(e)).toList();
    }

    return User(
      usuarioId: json['usuarioId'] as String? ?? json['id'] as String? ?? '',
      nome: json['nome'] as String?,
      email: json['email'] as String?,
      telefone: json['telefone'] as String?,
      tipo: json['tipo'] as String? ?? 'usuario',
      senha: json['senha'] as String?,
      adminId: json['adminId'] as String?,
      role: roleFromString(json['role'] as String?),
      eventos: eventosFromJson(json['eventos'] as List<dynamic>?),
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    String roleToString() {
      switch (role) {
        case UserRole.ADMIN:
          return 'ADMIN';
        case UserRole.USER:
          return 'USER';
        default:
          return 'USER';
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

  bool hasAdminRole() {
    return role == UserRole.ADMIN;
  }
}

import 'administrador.dart';
import 'recrutador.dart';
import 'evento.dart';

enum UserRole { admin, user, invalid }

class User {
  final String usuarioId;
  final String nome;
  final String email;
  final String telefone;
  final String? senha;
  final UserRole role;
  final String? adminId;
  final List<Evento>? eventos;
  final String? token;

  User({
    required this.usuarioId,
    required this.nome,
    required this.email,
    required this.telefone,
    this.senha,
    required this.role,
    this.adminId,
    this.eventos,
    this.token,
  });

  factory User.fromAdmin(Administrador admin) {
    return User(
      usuarioId: admin.usuarioId,
      nome: admin.nome,
      email: admin.email,
      telefone: admin.telefone,
      role: UserRole.admin,
      eventos: admin.adminEventos,
      token: admin.token,
    );
  }

  factory User.fromRecrutador(Recrutador recrutador) {
    return User(
      usuarioId: recrutador.usuarioId ?? '',
      nome: recrutador.nome,
      email: recrutador.email,
      telefone: recrutador.telefone,
      role: UserRole.user,
      adminId: recrutador.adminId,
      eventos: recrutador.eventos,
      token: recrutador.token,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    UserRole roleFromString(String? roleStr) {
      switch (roleStr?.toLowerCase()) {
        case 'admin':
        case 'role_admin':
          return UserRole.admin;
        case 'user':
        case 'role_user':
          return UserRole.user;
        default:
          return UserRole.invalid;
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
      telefone: json['telefone'] ?? '',
      senha: json['senha'],
      role: roleFromString(json['role']),
      adminId: json['adminId'],
      eventos: eventosFromJson(json['eventos']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    String roleToString() {
      switch (role) {
        case UserRole.admin:
          return 'ROLE_ADMIN';
        case UserRole.user:
          return 'ROLE_USER';
        case UserRole.invalid:
          return 'ROLE_INVALID';
      }
    }

    return {
      'usuarioId': usuarioId,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'senha': senha,
      'role': roleToString(),
      'adminId': adminId,
      'eventos': eventos?.map((e) => e.toJson()).toList(),
      'token': token,
    };
  }

  User copyWith({
    String? usuarioId,
    String? nome,
    String? email,
    String? telefone,
    String? senha,
    UserRole? role,
    String? adminId,
    List<Evento>? eventos,
    String? token,
  }) {
    return User(
      usuarioId: usuarioId ?? this.usuarioId,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      senha: senha ?? this.senha,
      role: role ?? this.role,
      adminId: adminId ?? this.adminId,
      eventos: eventos ?? this.eventos,
      token: token ?? this.token,
    );
  }

  // Getters para compatibilidade com código existente
  String get tipo {
    switch (role) {
      case UserRole.admin:
        return 'admin';
      case UserRole.user:
        return 'recrutador';
      case UserRole.invalid:
        return 'usuario';
    }
  }

  bool hasAdminRole() => role == UserRole.admin;
  bool isAdmin() => role == UserRole.admin;
  bool isRecrutador() => role == UserRole.user;
  bool isCandidato() => role == UserRole.invalid;

  @override
  String toString() {
    return 'User{usuarioId: $usuarioId, nome: $nome, email: $email, role: $role}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.usuarioId == usuarioId;
  }

  @override
  int get hashCode => usuarioId.hashCode;
}

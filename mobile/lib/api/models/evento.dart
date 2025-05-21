class FormularioSimplificado {
  final String id;
  final String titulo;

  FormularioSimplificado({required this.id, required this.titulo});

  factory FormularioSimplificado.fromJson(Map<String, dynamic> json) {
    return FormularioSimplificado(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'titulo': titulo};
  }
}

class UsuarioSimplificado {
  final String id;
  final String nome;

  UsuarioSimplificado({required this.id, required this.nome});

  factory UsuarioSimplificado.fromJson(Map<String, dynamic> json) {
    return UsuarioSimplificado(
      id: json['id'] as String? ?? json['usuarioId'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome};
  }
}

class Evento {
  final String id;
  final String nome;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String local;
  final String descricao;
  final List<FormularioSimplificado> formulariosAssociados;
  final List<UsuarioSimplificado> recrutadoresEnvolvidos;
  final List<UsuarioSimplificado> administradoresEnvolvidos;
  final String status;
  final String? adminId;

  Evento({
    required this.id,
    required this.nome,
    required this.dataInicio,
    required this.dataFim,
    required this.local,
    required this.descricao,
    required this.formulariosAssociados,
    required this.recrutadoresEnvolvidos,
    required this.administradoresEnvolvidos,
    required this.status,
    this.adminId,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
      dataInicio:
          json['dataInicio'] is String
              ? DateTime.parse(json['dataInicio'] as String)
              : DateTime.now(),
      dataFim:
          json['dataFim'] is String
              ? DateTime.parse(json['dataFim'] as String)
              : DateTime.now().add(const Duration(days: 1)),
      local: json['local'] as String? ?? '',
      descricao: json['descricao'] as String? ?? '',
      formulariosAssociados:
          (json['formulariosAssociados'] as List<dynamic>? ?? [])
              .map(
                (e) =>
                    FormularioSimplificado.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      recrutadoresEnvolvidos:
          (json['recrutadoresEnvolvidos'] as List<dynamic>? ?? [])
              .map(
                (e) => UsuarioSimplificado.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      administradoresEnvolvidos:
          (json['administradoresEnvolvidos'] as List<dynamic>? ?? [])
              .map(
                (e) => UsuarioSimplificado.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      status: json['status'] as String? ?? 'ATIVO',
      adminId: json['adminId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'dataInicio': dataInicio.toIso8601String(),
      'dataFim': dataFim.toIso8601String(),
      'local': local,
      'descricao': descricao,
      'formulariosAssociados':
          formulariosAssociados.map((e) => e.toJson()).toList(),
      'recrutadoresEnvolvidos':
          recrutadoresEnvolvidos.map((e) => e.toJson()).toList(),
      'administradoresEnvolvidos':
          administradoresEnvolvidos.map((e) => e.toJson()).toList(),
      'status': status,
      'adminId': adminId,
    };
  }

  Evento copyWith({
    String? id,
    String? nome,
    DateTime? dataInicio,
    DateTime? dataFim,
    String? local,
    String? descricao,
    List<FormularioSimplificado>? formulariosAssociados,
    List<UsuarioSimplificado>? recrutadoresEnvolvidos,
    List<UsuarioSimplificado>? administradoresEnvolvidos,
    String? status,
    String? adminId,
  }) {
    return Evento(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      local: local ?? this.local,
      descricao: descricao ?? this.descricao,
      formulariosAssociados:
          formulariosAssociados ?? this.formulariosAssociados,
      recrutadoresEnvolvidos:
          recrutadoresEnvolvidos ?? this.recrutadoresEnvolvidos,
      administradoresEnvolvidos:
          administradoresEnvolvidos ?? this.administradoresEnvolvidos,
      status: status ?? this.status,
      adminId: adminId ?? this.adminId,
    );
  }
}

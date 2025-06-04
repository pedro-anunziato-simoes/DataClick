class FormularioSimplificado {
  final String id;
  final String titulo;

  FormularioSimplificado({required this.id, required this.titulo});

  factory FormularioSimplificado.fromJson(Map<String, dynamic> json) {
    return FormularioSimplificado(
      id: json['id'] as String? ?? '',
      titulo: json['titulo'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'titulo': titulo};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormularioSimplificado &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsuarioSimplificado &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Evento && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Evento{id: $id, nome: $nome, status: $status}';
  }

  /// Verifica se o evento está ativo
  bool get isAtivo => status.toLowerCase() == 'ativo';

  /// Verifica se o evento está agendado
  bool get isAgendado => status.toLowerCase() == 'agendado';

  /// Verifica se o evento está em andamento
  bool get isEmAndamento => status.toLowerCase() == 'em andamento';

  /// Verifica se o evento está finalizado
  bool get isFinalizado => status.toLowerCase() == 'finalizado';

  /// Retorna a duração do evento em dias
  int get duracaoEmDias => dataFim.difference(dataInicio).inDays;

  /// Verifica se o evento já passou
  bool get jaPassou => DateTime.now().isAfter(dataFim);

  /// Verifica se o evento está acontecendo agora
  bool get estaHappeningNow {
    final agora = DateTime.now();
    return agora.isAfter(dataInicio) && agora.isBefore(dataFim);
  }
}

class EventoSimplificado {
  final String eventoAdminId;
  final String? eventoTitulo;
  final String? eventoDescricao;
  final DateTime? eventoData;
  final List<dynamic> eventoFormularios;
  final String eventoId;

  EventoSimplificado({
    required this.eventoAdminId,
    this.eventoTitulo,
    this.eventoDescricao,
    this.eventoData,
    required this.eventoFormularios,
    required this.eventoId,
  });

  factory EventoSimplificado.fromJson(Map<String, dynamic> json) {
    return EventoSimplificado(
      eventoAdminId: json['eventoAdminId'] as String? ?? '',
      eventoTitulo: json['eventoTitulo'] as String?,
      eventoDescricao: json['eventoDescricao'] as String?,
      eventoData:
          json['eventoData'] != null
              ? DateTime.parse(json['eventoData'] as String)
              : null,
      eventoFormularios: json['eventoFormularios'] as List<dynamic>? ?? [],
      eventoId: json['eventoId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventoAdminId': eventoAdminId,
      'eventoTitulo': eventoTitulo,
      'eventoDescricao': eventoDescricao,
      'eventoData': eventoData?.toIso8601String(),
      'eventoFormularios': eventoFormularios,
      'eventoId': eventoId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventoSimplificado &&
          runtimeType == other.runtimeType &&
          eventoId == other.eventoId;

  @override
  int get hashCode => eventoId.hashCode;
}

class ListaEventosSimplificados {
  final List<EventoSimplificado> eventos;

  ListaEventosSimplificados({required this.eventos});

  factory ListaEventosSimplificados.fromJson(List<dynamic> json) {
    return ListaEventosSimplificados(
      eventos:
          json
              .map(
                (e) => EventoSimplificado.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return eventos.map((e) => e.toJson()).toList();
  }

  EventoSimplificado? getEventoById(String eventoId) {
    try {
      return eventos.firstWhere((evento) => evento.eventoId == eventoId);
    } catch (e) {
      return null;
    }
  }

  List<String> getTodosIds() {
    return eventos.map((e) => e.eventoId).toList();
  }

  bool get isEmpty => eventos.isEmpty;
  bool get isNotEmpty => eventos.isNotEmpty;
  int get length => eventos.length;
}

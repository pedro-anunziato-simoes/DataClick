class FormularioSimplificado {
  final String id;
  final String titulo;

  FormularioSimplificado({required this.id, required this.titulo});

  factory FormularioSimplificado.fromJson(Map<String, dynamic> json) {
    return FormularioSimplificado(
      id: json["id"]?.toString() ?? "",
      titulo: json["formularioTitulo"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "titulo": titulo};
  }
}

class UsuarioSimplificado {
  final String id;
  final String nome;

  UsuarioSimplificado({required this.id, required this.nome});

  factory UsuarioSimplificado.fromJson(Map<String, dynamic> json) {
    return UsuarioSimplificado(
    id: json["id"]?.toString() ?? json["usuarioId"]?.toString() ?? "",
    nome: json["nome"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "nome": nome};
  }
}

class Evento {
  final String id;
  final String nome;
  final DateTime data;
  final String descricao;
  final List<FormularioSimplificado> formulariosAssociados;
  final List<UsuarioSimplificado> recrutadoresEnvolvidos;
  final List<UsuarioSimplificado> administradoresEnvolvidos;
  final String status;
  final String? adminId;

  Evento({
    required this.id,
    required this.nome,
    required this.data,
    required this.descricao,
    required this.formulariosAssociados,
    required this.recrutadoresEnvolvidos,
    required this.administradoresEnvolvidos,
    required this.status,
    this.adminId,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    print('Evento JSON: $json'); // Debug para identificar problemas de dados
    return Evento(
      id: json["eventoId"]?.toString() ?? "",
      nome: json["eventoTitulo"]?.toString() ?? "",
      data: json["eventoData"] != null
          ? DateTime.tryParse(json["eventoData"].toString()) ?? DateTime.now()
          : DateTime.now(),
      descricao: json["eventoDescricao"]?.toString() ?? "",
      formulariosAssociados: (json["eventoFormularios"] as List<dynamic>? ?? [])
          .map((e) => FormularioSimplificado.fromJson(e as Map<String, dynamic>))
          .toList(),
      recrutadoresEnvolvidos: (json["recrutadoresEnvolvidos"] as List<dynamic>? ?? [])
          .map((e) => UsuarioSimplificado.fromJson(e as Map<String, dynamic>))
          .toList(),
      administradoresEnvolvidos: (json["administradoresEnvolvidos"] as List<dynamic>? ?? [])
          .map((e) => UsuarioSimplificado.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json["status"]?.toString() ?? "ATIVO",
      adminId: json["eventoAdminId"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "eventoTituloDto": nome,
      "eventoDescricaoDto": descricao,
      "eventoDataDto": data.toIso8601String(),
    };
  }

  Evento copyWith({
    String? id,
    String? nome,
    DateTime? data,
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
      data: data ?? this.data,
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

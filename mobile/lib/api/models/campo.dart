class Campo {
  final String titulo;
  final String tipo;
  final Map<String, dynamic> resposta;
  final String campoId;

  Campo({
    required this.titulo,
    required this.tipo,
    required this.resposta,
    required this.campoId,
  });

  factory Campo.fromJson(Map<String, dynamic> json) {
    return Campo(
      titulo: json['campoTitulo'] ?? json['titulo'] ?? '',
      tipo: json['campoTipo'] ?? json['tipo'] ?? '',
      resposta: Map<String, dynamic>.from(json['resposta'] ?? {}),
      campoId: json['campoId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campoTitulo': titulo,
      'campoTipo': tipo,
      'resposta': resposta,
      'campoId': campoId,
    };
  }

  Map<String, dynamic> toCreateDto() {
    return {
      'campoTituloDto': titulo,
      'campoTipoDto': tipo,
      'resposta': resposta,
    };
  }

  Campo copyWith({
    String? titulo,
    String? tipo,
    Map<String, dynamic>? resposta,
    String? campoId,
  }) {
    return Campo(
      titulo: titulo ?? this.titulo,
      tipo: tipo ?? this.tipo,
      resposta: resposta ?? this.resposta,
      campoId: campoId ?? this.campoId,
    );
  }
}

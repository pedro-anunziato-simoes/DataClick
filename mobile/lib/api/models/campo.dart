class Campo {
 final String titulo;
  final String tipo;
  final dynamic resposta;
  final String campoId;
  final String? campoFormId;

  Campo({
   required this.titulo,
    required this.tipo,
    this.resposta, 
    required this.campoId,
    this.campoFormId,
  });

  factory Campo.fromJson(Map<String, dynamic> json) {
    return Campo(
      titulo: json['campoTitulo'] ?? json['titulo'] ?? '',
      tipo: json['campoTipo'] ?? json['tipo'] ?? '',
      resposta: Map<String, dynamic>.from(json['resposta'] ?? {}),
      campoId: json['campoId'] ?? '',
      campoFormId: json["campoFormId"]?.toString(), 
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "campoTitulo": titulo,
      "campoTipo": tipo,
      "resposta": resposta,
      "campoId": campoId,
      if (campoFormId != null) "campoFormId": campoFormId,
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
    dynamic? resposta,
    String? campoId,
    String? campoFormId, 
  }) {
    return Campo(
      titulo: titulo ?? this.titulo,
      tipo: tipo ?? this.tipo,
      resposta: resposta ?? this.resposta,
      campoId: campoId ?? this.campoId,
    );
  }
}

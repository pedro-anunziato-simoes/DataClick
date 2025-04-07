class Resposta {
  final String respostaId;
  final String tipo;
  final dynamic resposta;

  Resposta({
    required this.respostaId,
    required this.tipo,
    required this.resposta,
  });

  factory Resposta.fromJson(Map<String, dynamic> json) {
    return Resposta(
      respostaId: json['respostaId'] ?? '',
      tipo: json['tipo'] ?? 'TEXTO',
      resposta: json['resposta'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'respostaId': respostaId, 'tipo': tipo, 'resposta': resposta};
  }
}

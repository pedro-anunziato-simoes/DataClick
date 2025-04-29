class Resposta {
  final String respostaId;
  final String tipo;
  final String valor;

  Resposta({required this.respostaId, required this.tipo, required this.valor});

  factory Resposta.fromJson(Map<String, dynamic> json) {
    return Resposta(
      respostaId: json['respostaId'] ?? '',
      tipo: json['tipo'] ?? 'TEXTO',
      valor: json['valor'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'respostaId': respostaId, 'tipo': tipo, 'valor': valor};
  }
}

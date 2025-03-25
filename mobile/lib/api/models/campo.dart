class Campo {
  final String id;
  final String titulo;
  final String resposta;

  Campo({required this.id, required this.titulo, this.resposta = ''});

  factory Campo.fromJson(Map<String, dynamic> json) {
    return Campo(
      id: json['id'],
      titulo: json['titulo'],
      resposta: json['resposta'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'titulo': titulo, 'resposta': resposta};
  }
}

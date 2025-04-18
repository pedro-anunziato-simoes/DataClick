import 'resposta.dart';

class Campo {
  final String campoId;
  final String titulo;
  final String tipo;
  final Resposta resposta;
  final bool isObrigatorio;
  final String? descricao;
  final List<String>? opcoes;

  Campo({
    required this.campoId,
    required this.titulo,
    required this.tipo,
    required this.resposta,
    this.isObrigatorio = false,
    this.descricao,
    this.opcoes,
  });

  factory Campo.fromJson(Map<String, dynamic> json) {
    return Campo(
      campoId: json['campoId'] ?? '',
      titulo: json['titulo'] ?? '',
      tipo: json['tipo'] ?? 'TEXTO',
      resposta: Resposta.fromJson(json['resposta'] ?? {}),
      isObrigatorio: json['isObrigatorio'] ?? false,
      descricao: json['descricao'],
      opcoes: json['opcoes'] != null ? List<String>.from(json['opcoes']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campoId': campoId,
      'titulo': titulo,
      'tipo': tipo,
      'resposta': resposta.toJson(),
      'isObrigatorio': isObrigatorio,
      'descricao': descricao,
      'opcoes': opcoes,
    };
  }
}

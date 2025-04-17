import 'resposta.dart';

class Campo {
  final String campoId;
  final String titulo;
  final String tipo;
  final Resposta resposta;

  Campo({
    required this.campoId,
    required this.titulo,
    required this.tipo,
    required this.resposta,
  });

  factory Campo.fromJson(Map<String, dynamic> json) {
    return Campo(
      campoId: json['campoId']?.toString() ?? '',
      titulo: json['titulo']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? 'TEXTO',
      resposta: Resposta.fromJson(
        json['resposta'] is Map
            ? json['resposta']
            : {
              'respostaId': '',
              'tipo': json['tipo']?.toString() ?? 'TEXTO',
              'valor': json['resposta']?.toString() ?? '',
            },
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campoId': campoId,
      'titulo': titulo,
      'tipo': tipo,
      'resposta': resposta.toJson(),
    };
  }
}

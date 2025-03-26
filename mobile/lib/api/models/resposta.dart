import 'formulario.dart';

class Resposta {
  final String id;
  final Formulario formulario;

  Resposta({required this.id, required this.formulario});

  factory Resposta.fromJson(Map<String, dynamic> json) {
    return Resposta(
      id: json['id'],
      formulario: Formulario.fromJson(json['formulario']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'formulario': formulario.toJson()};
  }
}

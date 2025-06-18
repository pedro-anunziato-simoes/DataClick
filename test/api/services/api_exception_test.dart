import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/services/api_exception.dart';

void main() {
  group('ApiException', () {
    test('Construtor e propriedades', () {
      final ex = ApiException('Erro', 400);
      expect(ex.message, 'Erro');
      expect(ex.statusCode, 400);
    });
  });
}

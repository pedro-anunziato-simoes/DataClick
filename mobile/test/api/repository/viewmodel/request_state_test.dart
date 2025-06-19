import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/repository/viewmodel/request_state.dart';

void main() {
  group('RequestState', () {
    test('Estados básicos', () {
      expect(RequestState.loading, isNotNull);
      expect(RequestState.success, isNotNull);
      expect(RequestState.error, isNotNull);
    });
  });
}

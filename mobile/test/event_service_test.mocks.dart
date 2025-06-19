import 'dart:async' as _i5;

import 'package:http/http.dart' as _i2;
import '../../mobile/lib/api/api_client.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;

class _FakeResponse_0 extends _i1.SmartFake implements _i2.Response {
  _FakeResponse_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class MockApiClient extends _i1.Mock implements _i3.ApiClient {
  MockApiClient() {
    _i1.throwOnMissingStub(this);
  }

  String get baseUrl => (super.noSuchMethod(
        Invocation.getter(#baseUrl),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#baseUrl),
        ),
      ) as String);

  void setAuthToken(String? token) => super.noSuchMethod(
        Invocation.method(#setAuthToken, [token]),
        returnValueForMissingStub: null,
      );

  _i5.Future<_i2.Response> get(String? endpoint, {bool? includeAuth = true}) =>
      (super.noSuchMethod(
        Invocation.method(#get, [endpoint], {#includeAuth: includeAuth}),
        returnValue: _i5.Future<_i2.Response>.value(
          _FakeResponse_0(
            this,
            Invocation.method(
              #get,
              [endpoint],
              {#includeAuth: includeAuth},
            ),
          ),
        ),
      ) as _i5.Future<_i2.Response>);

  _i5.Future<_i2.Response> post(
    String? endpoint, {
    dynamic body,
    bool? includeAuth = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [endpoint],
          {#body: body, #includeAuth: includeAuth},
        ),
        returnValue: _i5.Future<_i2.Response>.value(
          _FakeResponse_0(
            this,
            Invocation.method(
              #post,
              [endpoint],
              {#body: body, #includeAuth: includeAuth},
            ),
          ),
        ),
      ) as _i5.Future<_i2.Response>);

  _i5.Future<_i2.Response> put(
    String? endpoint, {
    dynamic body,
    bool? includeAuth = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #put,
          [endpoint],
          {#body: body, #includeAuth: includeAuth},
        ),
        returnValue: _i5.Future<_i2.Response>.value(
          _FakeResponse_0(
            this,
            Invocation.method(
              #put,
              [endpoint],
              {#body: body, #includeAuth: includeAuth},
            ),
          ),
        ),
      ) as _i5.Future<_i2.Response>);

  _i5.Future<_i2.Response> delete(
    String? endpoint, {
    bool? includeAuth = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(#delete, [endpoint], {#includeAuth: includeAuth}),
        returnValue: _i5.Future<_i2.Response>.value(
          _FakeResponse_0(
            this,
            Invocation.method(
              #delete,
              [endpoint],
              {#includeAuth: includeAuth},
            ),
          ),
        ),
      ) as _i5.Future<_i2.Response>);
}

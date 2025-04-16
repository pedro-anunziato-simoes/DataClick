import 'package:flutter/foundation.dart';
import 'package:mobile/api/models/formulario.dart';
import 'package:mobile/api/models//campo.dart';
import 'package:mobile/api/repository/forms_repository.dart';

abstract class RequestState<T> {
  const RequestState();
}

class InitialState<T> extends RequestState<T> {
  const InitialState();
}

class LoadingState<T> extends RequestState<T> {
  const LoadingState();
}

class SuccessState<T> extends RequestState<T> {
  final T data;
  const SuccessState(this.data);
}

class ErrorState<T> extends RequestState<T> {
  final String message;
  const ErrorState(this.message);
}

class FormViewModel extends ChangeNotifier {
  final IFormularioRepository _repository;
  RequestState<List<Formulario>> _formularios = const InitialState();
  RequestState<Formulario?> _formularioAtual = const InitialState();

  String? _adminId;

  FormViewModel(this._repository);

  // Getters
  RequestState<List<Formulario>> get formularios => _formularios;
  RequestState<Formulario?> get formularioAtual => _formularioAtual;
  bool get isLoading =>
      _formularios is LoadingState || _formularioAtual is LoadingState;
  String? get adminId => _adminId;

  void setAdminId(String id) {
    _adminId = id;
    notifyListeners();
  }

  Future<void> carregarFormularios() async {
    try {
      _formularios = const LoadingState();
      notifyListeners();

      final result =
          _adminId != null
              ? await _repository.listarFormulariosPorAdmin(_adminId!)
              : await _repository.listarTodosFormularios();

      _formularios = SuccessState(result);
      notifyListeners();
    } catch (e) {
      _formularios = ErrorState(e.toString());
      notifyListeners();
    }
  }

  Future<void> obterFormularioPorId(String id) async {
    try {
      _formularioAtual = const LoadingState();
      notifyListeners();

      final result = await _repository.obterFormularioPorId(id);

      _formularioAtual = SuccessState(result);
      notifyListeners();
    } catch (e) {
      _formularioAtual = ErrorState(e.toString());
      notifyListeners();
    }
  }

  Future<void> criarFormulario(String titulo, List<Campo> campos) async {
    if (_adminId == null) {
      _formularioAtual = const ErrorState('Administrador não autenticado');
      notifyListeners();
      return;
    }

    try {
      _formularioAtual = const LoadingState();
      notifyListeners();

      final result = await _repository.criarFormulario(
        _adminId!,
        titulo,
        campos,
      );

      _formularioAtual = SuccessState(result);

      await carregarFormularios();
      notifyListeners();
    } catch (e) {
      _formularioAtual = ErrorState(e.toString());
      notifyListeners();
    }
  }

  Future<void> atualizarFormulario(
    String formId,
    String titulo,
    List<Campo> campos,
  ) async {
    if (_adminId == null) {
      _formularioAtual = const ErrorState('Administrador não autenticado');
      notifyListeners();
      return;
    }

    try {
      _formularioAtual = const LoadingState();
      notifyListeners();

      final result = await _repository.atualizarFormulario(
        formId,
        _adminId!,
        titulo,
        campos,
      );

      _formularioAtual = SuccessState(result);
      await carregarFormularios();
      notifyListeners();
    } catch (e) {
      _formularioAtual = ErrorState(e.toString());
      notifyListeners();
    }
  }

  Future<void> removerFormulario(String id) async {
    try {
      await _repository.removerFormulario(id);
      await carregarFormularios();
    } catch (e) {
      rethrow;
    }
  }

  void limparFormularioAtual() {
    _formularioAtual = const InitialState();
    notifyListeners();
  }
}

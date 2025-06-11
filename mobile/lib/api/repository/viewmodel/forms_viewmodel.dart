import 'package:flutter/foundation.dart';
import 'package:mobile/api/models/formulario.dart';
import 'package:mobile/api/models/campo.dart';
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
  RequestState<List<Formulario>> _formulariosPreenchidos = const InitialState();
  RequestState<Formulario?> _formularioAtual = const InitialState();
  bool _isAdmin = false;

  FormViewModel(this._repository);

  RequestState<List<Formulario>> get formularios => _formularios;
  RequestState<List<Formulario>> get formulariosPreenchidos =>
      _formulariosPreenchidos;
  RequestState<Formulario?> get formularioAtual => _formularioAtual;
  bool get isLoading =>
      _formularios is LoadingState ||
      _formularioAtual is LoadingState ||
      _formulariosPreenchidos is LoadingState;
  bool get isAdmin => _isAdmin;

  void setIsAdmin(bool isAdmin) {
    _isAdmin = isAdmin;
    notifyListeners();
  }

  Future<void> carregarFormulariosPorEvento(String eventoId) async {
    try {
      _formularios = const LoadingState();
      notifyListeners();

      final result = await _repository.listarFormulariosPorEvento(eventoId);
      _formularios = SuccessState(result);
      notifyListeners();
    } catch (e) {
      _formularios = ErrorState(e.toString());
      notifyListeners();
      rethrow;
    }
  }

  Future<void> carregarFormulariosPreenchidos(String eventoId) async {
    try {
      _formulariosPreenchidos = const LoadingState();
      notifyListeners();

      final result = await _repository.listarFormulariosPreenchidos(eventoId);
      _formulariosPreenchidos = SuccessState(result);
      notifyListeners();
    } catch (e) {
      _formulariosPreenchidos = ErrorState(e.toString());
      notifyListeners();
      rethrow;
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
      rethrow;
    }
  }

  Future<void> criarFormulario({
    required String titulo,
    required String eventoId,
    required List<Campo> campos,
    String? descricao,
  }) async {
    try {
      if (!_isAdmin) {
        throw Exception('Apenas administradores podem criar formulários');
      }

      _formularioAtual = const LoadingState();
      notifyListeners();

      final result = await _repository.criarFormulario(
        titulo: titulo,
        eventoId: eventoId,
        campos: campos,
        descricao: descricao,
      );

      _formularioAtual = SuccessState(result);
      await carregarFormulariosPorEvento(eventoId);
      notifyListeners();
    } catch (e) {
      _formularioAtual = ErrorState(e.toString());
      notifyListeners();
      rethrow;
    }
  }

  Future<void> atualizarFormulario({
    required String formId,
    required String titulo,
    required List<Campo> campos,
    String? descricao,
  }) async {
    try {
      if (!_isAdmin) {
        throw Exception('Apenas administradores podem atualizar formulários');
      }

      _formularioAtual = const LoadingState();
      notifyListeners();

      final result = await _repository.atualizarFormulario(
        formId: formId,
        titulo: titulo,
        campos: campos,
        descricao: descricao,
      );

      _formularioAtual = SuccessState(result);

      if (_formularios is SuccessState<List<Formulario>>) {
        final currentList =
            (_formularios as SuccessState<List<Formulario>>).data;
        if (currentList.isNotEmpty) {
          await carregarFormulariosPorEvento(currentList.first.formularioEventoId ?? '');
        }
      }

      notifyListeners();
    } catch (e) {
      _formularioAtual = ErrorState(e.toString());
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removerFormulario(String id) async {
    try {
      if (!_isAdmin) {
        throw Exception('Apenas administradores podem remover formulários');
      }

      String? eventoId;
      if (_formularios is SuccessState<List<Formulario>>) {
        final formulario = (_formularios as SuccessState<List<Formulario>>).data
            .firstWhere(
              (f) => f.id == id,
              orElse:
                  () => Formulario(id: '', formularioTitulo: '', formAdminId: '', campos: []),
            );
        eventoId = formulario.formularioEventoId;
      }

      await _repository.removerFormulario(id);

      if (eventoId != null) {
        await carregarFormulariosPorEvento(eventoId);
      }
    } catch (e) {
      rethrow;
    }
  }

  void limparFormularioAtual() {
    _formularioAtual = const InitialState();
    notifyListeners();
  }

  void limparFormulariosPreenchidos() {
    _formulariosPreenchidos = const InitialState();
    notifyListeners();
  }
}

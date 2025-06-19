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

  // Estados
  RequestState<List<Formulario>> _formulariosState = const InitialState();
  RequestState<List<Formulario>> _formulariosPreenchidosState =
      const InitialState();
  RequestState<Formulario?> _formularioAtualState = const InitialState();
  bool _isAdmin = false;

  FormViewModel(this._repository);

  // Getters
  RequestState<List<Formulario>> get formulariosState => _formulariosState;
  RequestState<List<Formulario>> get formulariosPreenchidosState =>
      _formulariosPreenchidosState;
  RequestState<Formulario?> get formularioAtualState => _formularioAtualState;
  bool get isLoading =>
      _formulariosState is LoadingState ||
      _formularioAtualState is LoadingState ||
      _formulariosPreenchidosState is LoadingState;
  bool get isAdmin => _isAdmin;

  // Setters
  void setIsAdmin(bool isAdmin) {
    _isAdmin = isAdmin;
    notifyListeners();
  }

  // Métodos para carregar dados
  Future<void> carregarFormulariosPorEvento(String eventoId) async {
    try {
      _formulariosState = const LoadingState();
      notifyListeners();

      final formularios = await _repository.listarFormulariosPorEvento(
        eventoId,
      );
      _formulariosState = SuccessState(formularios);
    } catch (e) {
      _formulariosState = ErrorState(_tratarMensagemErro(e));
    } finally {
      notifyListeners();
    }
  }

  Future<void> carregarFormulariosPreenchidos(String eventoId) async {
    try {
      _formulariosPreenchidosState = const LoadingState();
      notifyListeners();

      final formularios = await _repository.listarFormulariosPreenchidos(
        eventoId,
      );
      _formulariosPreenchidosState = SuccessState(formularios);
    } catch (e) {
      _formulariosPreenchidosState = ErrorState(_tratarMensagemErro(e));
    } finally {
      notifyListeners();
    }
  }

  Future<void> obterFormularioPorId(String id) async {
    try {
      _formularioAtualState = const LoadingState();
      notifyListeners();

      final formulario = await _repository.obterFormularioPorId(id);
      _formularioAtualState = SuccessState(formulario);
    } catch (e) {
      _formularioAtualState = ErrorState(_tratarMensagemErro(e));
    } finally {
      notifyListeners();
    }
  }

  // Métodos para manipulação de formulários
  Future<void> criarFormulario({
    required String titulo,
    required String eventoId,
    required String adminId,
    required List<Campo> campos,
    String? descricao,
  }) async {
    try {
      _validarPermissoesAdmin();
      _formularioAtualState = const LoadingState();
      notifyListeners();

      final novoFormulario = await _repository.criarFormulario(
        titulo: titulo,
        eventoId: eventoId,
        adminId: adminId,
        campos: campos,
        descricao: descricao,
      );

      _formularioAtualState = SuccessState(novoFormulario);
      await _atualizarListaFormularios(eventoId);
    } catch (e) {
      _formularioAtualState = ErrorState(_tratarMensagemErro(e));
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> atualizarFormulario({
    required String formId,
    required String titulo,
    required List<Campo> campos,
    String? descricao,
  }) async {
    try {
      _validarPermissoesAdmin();
      _formularioAtualState = const LoadingState();
      notifyListeners();

      final formularioAtualizado = await _repository.atualizarFormulario(
        formId: formId,
        titulo: titulo,
        campos: campos,
        descricao: descricao,
      );

      _formularioAtualState = SuccessState(formularioAtualizado);
      await _atualizarListaFormularios(formularioAtualizado.eventoId);
    } catch (e) {
      _formularioAtualState = ErrorState(_tratarMensagemErro(e));
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> removerFormulario(String id) async {
    try {
      _validarPermissoesAdmin();

      final eventoId = _obterEventoIdDoFormulario(id);
      await _repository.removerFormulario(id);

      if (eventoId != null) {
        await _atualizarListaFormularios(eventoId);
      }
    } catch (e) {
      _formularioAtualState = ErrorState(_tratarMensagemErro(e));
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> enviarRespostasFormulario({
    required String formId,
    required Map<String, dynamic> respostas,
  }) async {
    try {
      await _repository.enviarRespostasFormulario(
        formId: formId,
        respostas: respostas,
      );
    } catch (e) {
      _formularioAtualState = ErrorState(_tratarMensagemErro(e));
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  // Métodos auxiliares
  void limparFormularioAtual() {
    _formularioAtualState = const InitialState();
    notifyListeners();
  }

  void limparFormulariosPreenchidos() {
    _formulariosPreenchidosState = const InitialState();
    notifyListeners();
  }

  // Métodos privados
  Future<void> _atualizarListaFormularios(String? eventoId) async {
    if (eventoId != null &&
        _formulariosState is SuccessState<List<Formulario>>) {
      await carregarFormulariosPorEvento(eventoId);
    }
  }

  String? _obterEventoIdDoFormulario(String formId) {
    if (_formulariosState is SuccessState<List<Formulario>>) {
      final formularios =
          (_formulariosState as SuccessState<List<Formulario>>).data;
      return formularios
          .firstWhere(
            (f) => f.id == formId,
            orElse:
                () => Formulario(id: '', titulo: '', adminId: '', campos: []),
          )
          .eventoId;
    }
    return null;
  }

  void _validarPermissoesAdmin() {
    if (!_isAdmin) {
      throw Exception('Apenas administradores podem realizar esta ação');
    }
  }

  String _tratarMensagemErro(dynamic error) {
    if (error is String) return error;
    if (error is Exception) return error.toString();
    return 'Ocorreu um erro inesperado';
  }

  Future<void> adicionarFormulariosPreenchidos(
    String eventoId,
    List<Formulario> formularios,
  ) async {
    try {
      _formulariosPreenchidosState = const LoadingState();
      notifyListeners();

      await _repository.adicionarFormulariosPreenchidos(
        eventoId: eventoId,
        formularios: formularios,
      );

      _formulariosPreenchidosState = SuccessState(formularios);
    } catch (e) {
      _formulariosPreenchidosState = ErrorState(_tratarMensagemErro(e));
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}

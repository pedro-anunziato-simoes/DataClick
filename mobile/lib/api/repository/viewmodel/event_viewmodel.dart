import 'package:flutter/foundation.dart';
import 'package:mobile/api/models/evento.dart';
import 'package:mobile/api/services/event_service.dart';
import 'package:mobile/api/services/api_exception.dart';
import 'package:mobile/api/repository/viewmodel/auth_viewmodel.dart';

abstract class RequestState<T> {}

class InitialState<T> extends RequestState<T> {}

class LoadingState<T> extends RequestState<T> {}

class ErrorState<T> extends RequestState<T> {
  final String error;
  ErrorState(this.error);
}

class SuccessState<T> extends RequestState<T> {
  final T data;
  SuccessState(this.data);
}

class EventViewModel extends ChangeNotifier {
  final EventService _eventService;
  final AuthViewModel _authViewModel;

  RequestState<List<Evento>> _eventos = InitialState();
  RequestState<Evento?> _eventoAtual = InitialState();

  EventViewModel(this._eventService, this._authViewModel);

  RequestState<List<Evento>> get eventos => _eventos;
  RequestState<Evento?> get eventoAtual => _eventoAtual;
  bool get isLoading =>
      _eventos is LoadingState || _eventoAtual is LoadingState;
  bool get isAdmin => _authViewModel.isAdmin;

  Future<void> carregarEventos() async {
    try {
      _eventos = LoadingState();
      notifyListeners();

      final result = await _eventService.listarEventos();
      _eventos = SuccessState(result);
    } on ApiException catch (e) {
      _eventos = ErrorState(e.message);
    } catch (e) {
      _eventos = ErrorState(
        'Ocorreu um erro inesperado ao carregar eventos: ${e.toString()}',
      );
    }
    notifyListeners();
  }

  Future<void> obterEventoPorId(String id) async {
    try {
      _eventoAtual = LoadingState();
      notifyListeners();

      final result = await _eventService.obterEventoPorId(id);
      _eventoAtual = SuccessState(result);
    } on ApiException catch (e) {
      _eventoAtual = ErrorState(e.message);
    } catch (e) {
      _eventoAtual = ErrorState(
        'Ocorreu um erro inesperado ao obter evento: ${e.toString()}',
      );
    }
    notifyListeners();
  }

  Future<bool> criarEvento(Evento evento) async {
    if (!isAdmin) return false;

    try {
      _eventoAtual = LoadingState();
      notifyListeners();

      final result = await _eventService.criarEvento(evento);
      _eventoAtual = SuccessState(result);
      await carregarEventos();

      return true;
    } on ApiException catch (e) {
      _eventoAtual = ErrorState(e.message);
      notifyListeners();
      return false;
    } catch (e) {
      _eventoAtual = ErrorState(
        'Ocorreu um erro inesperado ao criar evento: ${e.toString()}',
      );
      notifyListeners();
      return false;
    }
  }

  Future<bool> atualizarEvento(String id, Evento evento) async {
    if (!isAdmin) return false;

    try {
      _eventoAtual = LoadingState();
      notifyListeners();

      final result = await _eventService.atualizarEvento(id, evento);
      _eventoAtual = SuccessState(result);
      await carregarEventos();

      return true;
    } on ApiException catch (e) {
      _eventoAtual = ErrorState(e.message);
      notifyListeners();
      return false;
    } catch (e) {
      _eventoAtual = ErrorState(
        'Ocorreu um erro inesperado ao atualizar evento: ${e.toString()}',
      );
      notifyListeners();
      return false;
    }
  }

  Future<bool> removerEvento(String id) async {
    if (!isAdmin) return false;

    try {
      _eventos = LoadingState();
      notifyListeners();

      await _eventService.removerEvento(id);
      await carregarEventos();

      return true;
    } on ApiException catch (e) {
      _eventos = ErrorState(e.message);
      notifyListeners();
      return false;
    } catch (e) {
      _eventos = ErrorState(
        'Ocorreu um erro inesperado ao remover evento: ${e.toString()}',
      );
      notifyListeners();
      return false;
    }
  }

  void limparEventoAtual() {
    _eventoAtual = InitialState();
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:mobile/api/models/evento.dart';
import 'package:mobile/api/services/event_service.dart';
import 'package:mobile/api/services/api_exception.dart';
import 'package:mobile/api/repository/viewmodel/auth_viewmodel.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? _eventoIdAtual;

  EventViewModel(this._eventService, this._authViewModel) {
    _lerListaEventosDoCacheEAtribuir();
    _lerEventoIdDoCache();
  }

  RequestState<List<Evento>> get eventos => _eventos;
  RequestState<Evento?> get eventoAtual => _eventoAtual;
  String? get eventoIdAtual => _eventoIdAtual;
  bool get isLoading =>
      _eventos is LoadingState || _eventoAtual is LoadingState;
  bool get isAdmin => _authViewModel.isAdmin;

  Future<void> _salvarEventoIdNoCache(String eventoId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('evento_id_atual', eventoId);
  }

  Future<void> _lerEventoIdDoCache() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('evento_id_atual');
    if (id != null) {
      _eventoIdAtual = id;
      notifyListeners();
      await obterEventoDoCache(id);
    }
  }

  Future<void> _salvarEventoNoCache(Evento evento) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'evento_json_${evento.eventoId}',
      jsonEncode(evento.toJson()),
    );
  }

  Future<void> obterEventoDoCache(String eventoId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('evento_json_$eventoId');
    if (jsonString != null) {
      try {
        final evento = Evento.fromJson(jsonDecode(jsonString));
        _eventoAtual = SuccessState(evento);
        notifyListeners();
      } catch (e) {
        // Se der erro, ignora o cache
      }
    }
  }

  Future<void> _salvarListaEventosNoCache(List<Evento> eventos) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'eventos_lista_json',
      jsonEncode(eventos.map((e) => e.toJson()).toList()),
    );
  }

  Future<List<Evento>> _lerListaEventosDoCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('eventos_lista_json');
    if (jsonString != null) {
      try {
        final List<dynamic> list = jsonDecode(jsonString);
        return list.map((e) => Evento.fromJson(e)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  Future<void> _lerListaEventosDoCacheEAtribuir() async {
    final eventos = await _lerListaEventosDoCache();
    if (eventos.isNotEmpty) {
      _eventos = SuccessState(eventos);
      notifyListeners();
    }
  }

  Future<void> carregarEventos() async {
    try {
      _eventos = LoadingState();
      notifyListeners();

      final result = await _eventService.listarEventos();
      _eventos = SuccessState(result);
      await _salvarListaEventosNoCache(result);
    } on ApiException catch (e) {
      final cache = await _lerListaEventosDoCache();
      if (cache.isNotEmpty) {
        _eventos = SuccessState(cache);
      } else {
        _eventos = ErrorState(e.message);
      }
    } catch (e) {
      final cache = await _lerListaEventosDoCache();
      if (cache.isNotEmpty) {
        _eventos = SuccessState(cache);
      } else {
        _eventos = ErrorState(
          'Ocorreu um erro inesperado ao carregar eventos: ${e.toString()}',
        );
      }
    }
    notifyListeners();
  }

  Future<void> obterEventoPorId(String id) async {
    try {
      _eventoAtual = LoadingState();
      notifyListeners();

      final result = await _eventService.obterEventoPorId(id);
      _eventoAtual = SuccessState(result);
      _eventoIdAtual = id;
      await _salvarEventoIdNoCache(id);
      await _salvarEventoNoCache(result);
    } on ApiException catch (e) {
      _eventoAtual = ErrorState(e.message);
      notifyListeners();
      await obterEventoDoCache(id); // tenta do cache se falhar
    } catch (e) {
      _eventoAtual = ErrorState(
        'Ocorreu um erro inesperado ao obter evento: ${e.toString()}',
      );
      notifyListeners();
      await obterEventoDoCache(id);
    }
    notifyListeners();
  }

  Future<bool> criarEvento(Evento evento) async {
    print('DEBUG: [EventViewModel] criarEvento chamado');
    if (!isAdmin) {
      print('DEBUG: [EventViewModel] Usuário não é admin, abortando');
      return false;
    }

    try {
      print('DEBUG: [EventViewModel] Chamando _eventService.criarEvento...');
      _eventoAtual = LoadingState();
      notifyListeners();

      final result = await _eventService.criarEvento(evento);
      print(
        'DEBUG: [EventViewModel] Evento criado com sucesso: ${result.eventoId}',
      );
      _eventoAtual = SuccessState(result);
      await _salvarEventoNoCache(result);
      await carregarEventos();

      return true;
    } on ApiException catch (e) {
      print('DEBUG: [EventViewModel] ApiException: ${e.message}');
      _eventoAtual = ErrorState(e.message);
      notifyListeners();
      return false;
    } catch (e) {
      print('DEBUG: [EventViewModel] Erro inesperado: ${e.toString()}');
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
      await _salvarEventoNoCache(result);
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
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('evento_json_$id');
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

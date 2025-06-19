import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/api/models/evento.dart';
import 'package:mobile/api/services/event_service.dart';

// Eventos
abstract class EventEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CarregarEventos extends EventEvent {}

class CarregarEventoPorId extends EventEvent {
  final String eventoId;
  CarregarEventoPorId(this.eventoId);
  @override
  List<Object?> get props => [eventoId];
}

// Estados
abstract class EventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final List<Evento> eventos;
  EventLoaded(this.eventos);
  @override
  List<Object?> get props => [eventos];
}

class EventoLoaded extends EventState {
  final Evento evento;
  EventoLoaded(this.evento);
  @override
  List<Object?> get props => [evento];
}

class EventError extends EventState {
  final String message;
  EventError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class EventBloc extends Bloc<EventEvent, EventState> {
  final EventService eventService;

  EventBloc({required this.eventService}) : super(EventInitial()) {
    on<CarregarEventos>(_onCarregarEventos);
    on<CarregarEventoPorId>(_onCarregarEventoPorId);
  }

  Future<void> _onCarregarEventos(
    CarregarEventos event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());
    try {
      final eventos = await eventService.listarEventos();
      emit(EventLoaded(eventos));
    } catch (e) {
      emit(EventError('Erro ao carregar eventos: ${e.toString()}'));
    }
  }

  Future<void> _onCarregarEventoPorId(
    CarregarEventoPorId event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());
    try {
      final evento = await eventService.obterEventoPorId(event.eventoId);
      emit(EventoLoaded(evento));
    } catch (e) {
      emit(EventError('Erro ao carregar evento: ${e.toString()}'));
    }
  }
}

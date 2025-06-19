import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/api/models/recrutador.dart';
import 'package:mobile/api/services/recrutador_service.dart';

// Eventos
abstract class RecrutadorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CarregarRecrutadorLogado extends RecrutadorEvent {}

class CarregarRecrutadorPorId extends RecrutadorEvent {
  final String recrutadorId;
  CarregarRecrutadorPorId(this.recrutadorId);
  @override
  List<Object?> get props => [recrutadorId];
}

// Estados
abstract class RecrutadorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RecrutadorInitial extends RecrutadorState {}

class RecrutadorLoading extends RecrutadorState {}

class RecrutadorLoaded extends RecrutadorState {
  final Recrutador recrutador;
  RecrutadorLoaded(this.recrutador);
  @override
  List<Object?> get props => [recrutador];
}

class RecrutadorError extends RecrutadorState {
  final String message;
  RecrutadorError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class RecrutadorBloc extends Bloc<RecrutadorEvent, RecrutadorState> {
  final RecrutadorService recrutadorService;

  RecrutadorBloc({required this.recrutadorService})
    : super(RecrutadorInitial()) {
    on<CarregarRecrutadorLogado>(_onCarregarRecrutadorLogado);
    on<CarregarRecrutadorPorId>(_onCarregarRecrutadorPorId);
  }

  Future<void> _onCarregarRecrutadorLogado(
    CarregarRecrutadorLogado event,
    Emitter<RecrutadorState> emit,
  ) async {
    emit(RecrutadorLoading());
    try {
      final recrutador = await recrutadorService.getRecrutadorLogado();
      emit(RecrutadorLoaded(recrutador));
    } catch (e) {
      emit(
        RecrutadorError('Erro ao carregar recrutador logado: ${e.toString()}'),
      );
    }
  }

  Future<void> _onCarregarRecrutadorPorId(
    CarregarRecrutadorPorId event,
    Emitter<RecrutadorState> emit,
  ) async {
    emit(RecrutadorLoading());
    try {
      final recrutador = await recrutadorService.getRecrutadorById(
        event.recrutadorId,
      );
      emit(RecrutadorLoaded(recrutador));
    } catch (e) {
      emit(RecrutadorError('Erro ao carregar recrutador: ${e.toString()}'));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/api/models/formulario.dart';
import 'package:mobile/api/services/formulario_service.dart';

// Eventos
abstract class FormularioEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CarregarFormulariosPorEvento extends FormularioEvent {
  final String eventoId;
  CarregarFormulariosPorEvento(this.eventoId);
  @override
  List<Object?> get props => [eventoId];
}

class CarregarFormularioPorId extends FormularioEvent {
  final String formularioId;
  CarregarFormularioPorId(this.formularioId);
  @override
  List<Object?> get props => [formularioId];
}

// Estados
abstract class FormularioState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FormularioInitial extends FormularioState {}

class FormularioLoading extends FormularioState {}

class FormulariosLoaded extends FormularioState {
  final List<Formulario> formularios;
  FormulariosLoaded(this.formularios);
  @override
  List<Object?> get props => [formularios];
}

class FormularioLoaded extends FormularioState {
  final Formulario formulario;
  FormularioLoaded(this.formulario);
  @override
  List<Object?> get props => [formulario];
}

class FormularioError extends FormularioState {
  final String message;
  FormularioError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class FormularioBloc extends Bloc<FormularioEvent, FormularioState> {
  final FormularioService formularioService;

  FormularioBloc({required this.formularioService})
    : super(FormularioInitial()) {
    on<CarregarFormulariosPorEvento>(_onCarregarFormulariosPorEvento);
    on<CarregarFormularioPorId>(_onCarregarFormularioPorId);
  }

  Future<void> _onCarregarFormulariosPorEvento(
    CarregarFormulariosPorEvento event,
    Emitter<FormularioState> emit,
  ) async {
    emit(FormularioLoading());
    try {
      final formularios = await formularioService.getFormulariosByEvento(
        event.eventoId,
      );
      emit(FormulariosLoaded(formularios));
    } catch (e) {
      emit(FormularioError('Erro ao carregar formulários: ${e.toString()}'));
    }
  }

  Future<void> _onCarregarFormularioPorId(
    CarregarFormularioPorId event,
    Emitter<FormularioState> emit,
  ) async {
    emit(FormularioLoading());
    try {
      final formulario = await formularioService.getFormularioById(
        event.formularioId,
      );
      emit(FormularioLoaded(formulario));
    } catch (e) {
      emit(FormularioError('Erro ao carregar formulário: ${e.toString()}'));
    }
  }
}

import '../services/formulario_service.dart';
import '../models/formulario.dart';
import '../models/campo.dart';

abstract class IFormularioRepository {
  Future<List<Formulario>> listarFormulariosPorEvento(String eventoId);
  Future<List<Formulario>> listarFormulariosPreenchidos(String eventoId);
  Future<Formulario> obterFormularioPorId(String id);
  Future<Formulario> criarFormulario({
    required String titulo,
    required String eventoId,
    required String adminId,
    required List<Campo> campos,
    String? descricao,
  });
  Future<Formulario> atualizarFormulario({
    required String formId,
    required String titulo,
    required List<Campo> campos,
    String? descricao,
  });
  Future<void> removerFormulario(String id);
}

class FormularioRepository implements IFormularioRepository {
  final FormularioService _formularioService;

  FormularioRepository(this._formularioService);

  @override
  Future<List<Formulario>> listarFormulariosPorEvento(String eventoId) async {
    try {
      return await _formularioService.getFormulariosByEvento(eventoId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Formulario>> listarFormulariosPreenchidos(String eventoId) async {
    try {
      return await _formularioService.getFormulariosPreenchidos(eventoId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Formulario> obterFormularioPorId(String id) async {
    try {
      return await _formularioService.getFormularioById(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Formulario> criarFormulario({
    required String titulo,
    required String eventoId,
    required String adminId,
    required List<Campo> campos,
    String? descricao,
  }) async {
    try {
      return await _formularioService.criarFormulario(
        titulo: titulo,
        eventoId: eventoId,
        adminId: adminId,
        campos: campos,
        descricao: descricao,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Formulario> atualizarFormulario({
    required String formId,
    required String titulo,
    required List<Campo> campos,
    String? descricao,
  }) async {
    try {
      return await _formularioService.alterarFormulario(
        formId: formId,
        titulo: titulo,
        campos: campos,
        descricao: descricao,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removerFormulario(String id) async {
    try {
      await _formularioService.removerFormulario(id);
    } catch (e) {
      rethrow;
    }
  }
}

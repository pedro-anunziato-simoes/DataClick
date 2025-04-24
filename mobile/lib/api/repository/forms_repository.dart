import '../services/formulario_service.dart';
import '../models/formulario.dart';
import '../models/campo.dart';

abstract class IFormularioRepository {
  Future<List<Formulario>> listarMeusFormularios();
  Future<List<Formulario>> listarTodosFormularios();
  Future<Formulario> obterFormularioPorId(String id);
  Future<Formulario> criarFormulario(String titulo, List<Campo> campos);
  Future<Formulario> atualizarFormulario(
    String formId,
    String titulo,
    List<Campo> campos,
  );
  Future<void> removerFormulario(String id);
}

class FormularioRepository implements IFormularioRepository {
  final FormularioService _formularioService;

  FormularioRepository(this._formularioService);

  @override
  Future<List<Formulario>> listarTodosFormularios() async {
    return await _formularioService.listarTodosFormularios();
  }

  @override
  Future<List<Formulario>> listarMeusFormularios() async {
    return await _formularioService.getMeusFormularios();
  }

  @override
  Future<Formulario> obterFormularioPorId(String id) async {
    return await _formularioService.obterFormularioPorId(id);
  }

  @override
  Future<Formulario> criarFormulario(String titulo, List<Campo> campos) async {
    return await _formularioService.criarFormulario(
      titulo: titulo,
      campos: campos,
    );
  }

  @override
  Future<Formulario> atualizarFormulario(
    String formId,
    String titulo,
    List<Campo> campos,
  ) async {
    return await _formularioService.atualizarFormulario(
      formId: formId,
      titulo: titulo,
      campos: campos,
    );
  }

  @override
  Future<void> removerFormulario(String id) async {
    await _formularioService.removerFormulario(id);
  }
}

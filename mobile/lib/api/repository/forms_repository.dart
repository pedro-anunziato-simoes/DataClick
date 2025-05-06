import '../services/formulario_service.dart';
import '../models/formulario.dart';
import '../models/campo.dart';

abstract class IFormularioRepository {
  Future<List<Formulario>> listarMeusFormularios();
  Future<Formulario> obterFormularioPorId(String id);
  Future<Formulario> criarFormulario(String titulo, List<Campo> campos);
  Future<Formulario> atualizarFormulario(
    String formId,
    String titulo,
    List<Campo> campos,
  );
  Future<Formulario> removerFormulario(String id);
}

class FormularioRepository implements IFormularioRepository {
  final FormularioService _formularioService;

  FormularioRepository(this._formularioService);

  @override
  Future<List<Formulario>> listarMeusFormularios() async {
    return await _formularioService.getFormularios();
  }

  @override
  Future<Formulario> obterFormularioPorId(String id) async {
    return await _formularioService.getFormularioById(id);
  }

  @override
  Future<Formulario> criarFormulario(String titulo, List<Campo> campos) async {
    Map<String, dynamic> data = {
      'titulo': titulo,
      'campos': campos.map((campo) => campo.toJson()).toList(),
    };
    return await _formularioService.criarForms(data);
  }

  @override
  Future<Formulario> atualizarFormulario(
    String formId,
    String titulo,
    List<Campo> campos,
  ) async {
    Map<String, dynamic> data = {
      'titulo': titulo,
      'campos': campos.map((campo) => campo.toJson()).toList(),
    };
    return await _formularioService.alterarForms(formId, data);
  }

  @override
  Future<Formulario> removerFormulario(String id) async {
    return await _formularioService.removerForms(id);
  }
}

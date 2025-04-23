import '../models/formulario.dart';
import '../models/campo.dart';
import '../services/formulario_service.dart';

// Interface do repositório para inversão de dependência
abstract class IFormularioRepository {
  Future<List<Formulario>> listarTodosFormularios();
  Future<List<Formulario>> listarFormulariosPorAdmin(String adminId);
  Future<Formulario> obterFormularioPorId(String id);
  Future<Formulario> criarFormulario(
    String adminId,
    String titulo,
    List<Campo> campos,
  );
  Future<Formulario> atualizarFormulario(
    String formId,
    String adminId,
    String titulo,
    List<Campo> campos,
  );
  Future<void> removerFormulario(String id);
}

// Implementação do repositório
class FormularioRepository implements IFormularioRepository {
  final FormularioService _service;

  FormularioRepository(this._service);

  @override
  Future<List<Formulario>> listarTodosFormularios() {
    return _service.listarTodosFormularios();
  }

  @override
  Future<List<Formulario>> listarFormulariosPorAdmin(String adminId) {
    return _service.listarFormulariosPorAdmin(adminId);
  }

  @override
  Future<Formulario> obterFormularioPorId(String id) {
    return _service.obterFormularioPorId(id);
  }

  @override
  Future<Formulario> criarFormulario(
    String adminId,
    String titulo,
    List<Campo> campos,
  ) {
    return _service.criarFormulario(adminId, titulo, campos);
  }

  @override
  Future<Formulario> atualizarFormulario(
    String formId,
    String adminId,
    String titulo,
    List<Campo> campos,
  ) {
    // Note que você precisará implementar essa funcionalidade no service
    // Caso não exista, podemos adaptar usando o método de criar
    return _service.criarFormulario(adminId, titulo, campos);
  }

  @override
  Future<void> removerFormulario(String id) {
    return _service.removerFormulario(id);
  }
}

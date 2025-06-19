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
  Future<void> enviarRespostasFormulario({
    required String formId,
    required Map<String, dynamic> respostas,
  });
  Future<void> adicionarFormulariosPreenchidos({
    required String eventoId,
    required List<Formulario> formularios,
  });
}

class FormularioRepository implements IFormularioRepository {
  final FormularioService _formularioService;

  FormularioRepository(this._formularioService);

  @override
  Future<List<Formulario>> listarFormulariosPorEvento(String eventoId) async {
    final formularios = await _formularioService.getFormulariosByEvento(
      eventoId,
    );
    return formularios;
  }

  @override
  Future<List<Formulario>> listarFormulariosPreenchidos(String eventoId) async {
    final formularios = await _formularioService.getFormulariosPreenchidos(
      eventoId,
    );
    return formularios;
  }

  @override
  Future<Formulario> obterFormularioPorId(String id) async {
    final formulario = await _formularioService.getFormularioById(id);
    return formulario;
  }

  @override
  Future<Formulario> criarFormulario({
    required String titulo,
    required String eventoId,
    required String adminId,
    required List<Campo> campos,
    String? descricao,
  }) async {
    final novoFormulario = await _formularioService.criarFormulario(
      titulo: titulo,
      eventoId: eventoId,
      adminId: adminId,
      campos: campos,
      descricao: descricao,
    );
    return novoFormulario;
  }

  @override
  Future<Formulario> atualizarFormulario({
    required String formId,
    required String titulo,
    required List<Campo> campos,
    String? descricao,
  }) async {
    final formularioAtualizado = await _formularioService.alterarFormulario(
      formId: formId,
      titulo: titulo,
      campos: campos,
      descricao: descricao,
    );
    return formularioAtualizado;
  }

  @override
  Future<void> removerFormulario(String id) async {
    await _formularioService.removerFormulario(id);
  }

  @override
  Future<void> adicionarFormulariosPreenchidos({
    required String eventoId,
    required List<Formulario> formularios,
  }) async {
    await _formularioService.adicionarFormulariosPreenchidos(
      eventoId: eventoId,
      formularios: formularios,
    );
  }

  @override
  Future<void> enviarRespostasFormulario({
    required String formId,
    required Map<String, dynamic> respostas,
  }) async {
    await _formularioService.enviarRespostasFormulario(
      formId: formId,
      respostas: respostas,
    );
  }
}

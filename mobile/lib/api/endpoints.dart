class Endpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  static const String administradores = '/administradores';
  static String removerAdministrador(String id) =>
      '$administradores/$id/remover';

  static const String recrutadores = '/recrutadores';
  static const String criarRecrutador = '/recrutadores';
  static String buscarRecrutador(String recrutadorId) =>
      '$recrutadores/$recrutadorId';
  static String listarRecrutadoresPorAdmin(String adminId) =>
      '$recrutadores/$adminId/list';
  static String removerRecrutador(String recrutadorId) =>
      '$recrutadores/remover/$recrutadorId';

  static const String formularios = '/formularios';
  static String buscarFormularioPorId(String id) => '$formularios/$id';
  static String listarFormulariosPorAdmin(String adminId) =>
      '$formularios/todos-formularios/';
  static String criarFormulario(String adminId) => '$formularios/add/';
  static String removerFormulario(String id) =>
      '$formularios/formualrio/remove/$id';

  static const String campos = '/campos';
  static String alterarCampo(String campoId) => '$campos/alterar/$campoId';
  static String buscarCampoPorId(String campoId) => '$campos/$campoId';
  static String adicionarCampo(String formId) => '$campos/add/$formId';
  static String camposPorFormulario(String formId) =>
      '$campos/findByFormId/$formId';
  static String removerCampo(String campoId) => '$campos/remover/$campoId';

  static const String formulariosPreenchidos = '/formulariosPreenchidos';
  static String adicionarFormularioPreenchido(String recrutadorId) =>
      '$formulariosPreenchidos/add/$recrutadorId';
  static String buscarFormularioPreenchidoPorRecrutador(String recrutadorId) =>
      '$formulariosPreenchidos/$recrutadorId';
}

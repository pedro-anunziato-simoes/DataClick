class Endpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  static const String administradores = '/administradores';
  static String removerAdministrador(String id) => '$administradores/$id/remover';
  static const String infoAdministrador = '$administradores/info';
  static const String alterarEmailAdministrador = '$administradores/alterar/email';
  static const String alterarSenhaAdministrador = '$administradores/alterar/senha';

  static const String recrutadores = '/recrutadores';
  static const String criarRecrutador = '/recrutadores';
  static String buscarRecrutador(String recrutadorId) =>'$recrutadores/$recrutadorId';
  static String listarRecrutadoresPorAdmin(String adminId) =>'$recrutadores/$adminId/list';
  static String removerRecrutador(String recrutadorId) => '$recrutadores/remover/$recrutadorId';

  static const String formularios = '/formularios';
  static String alterarFormulario(String formId) => '$formularios/alterar/$formId';
  static String criarFormulario(String eventoId) => '$formularios/add/$eventoId';
  static String removerFormulario(String id) => '$formularios/remove/$id';
  static String buscarFormularioPorId(String id) => '$formularios/$id';
  static String listarFormulariosPorEvento(String eventoId) => '$formularios/formulario/evento/$eventoId';

  static const String campos = '/campos';
  static String camposPorFormulario(String formId) => '$campos/findByFormId/$formId';
  static String adicionarCampo(String formId) => '$campos/add/$formId';
  static String removerCampo(String campoId) => '$campos/remover/$campoId';
  static String buscarCampoPorId(String campoId) => '$campos/$campoId';
  static String alterarCampo(String campoId) => '$campos/alterar/$campoId';

  static const String formulariosPreenchidos = '/formulariosPreenchidos';
  static String adicionarFormularioPreenchido(String recrutadorId) =>
      '$formulariosPreenchidos/add/$recrutadorId';
  static String buscarFormularioPreenchidoPorRecrutador(String recrutadorId) =>
      '$formulariosPreenchidos/$recrutadorId';
}
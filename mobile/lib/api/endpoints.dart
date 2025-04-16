class Endpoints {
  // Autenticação
  static const String login = '/login';
  static const String logout = '/logout';
  static const String perfil = '/perfil';

  // Administradores
  static const String administradores = '/administradores';
  static String removerAdministrador(String id) =>
      '$administradores/$id/remover';

  // Recrutadores
  static const String recrutadores = '/recrutadores';
  static String adicionarRecrutador(String adminId) =>
      '$recrutadores/$adminId/add';
  static String listarRecrutadoresPorAdmin(String adminId) =>
      '$recrutadores/$adminId/list';
  static String removerRecrutador(String id) => '$recrutadores/remover/$id';

  // Formulários
  static const String formularios = '/formularios';
  static String formulariosPorAdmin(String adminId) =>
      '/admin/$adminId/formularios';
  static String formularioPorId(String id) => '$formularios/$id';
  static String adicionarFormulario(String adminId) =>
      '$formularios/add/$adminId';
  static String removerFormulario(String id) => '$formularios/remove/$id';

  // Campos
  static const String campos = '/campos';
  static String alterarCampo(String campoId) => '$campos/alternr/$campoId';
  static String preencherCampo(String campoId) => '$campos/preencher/$campoId';
  static String adicionarCampo(String formId) => '$campos/add/$formId';
  static String camposPorFormulario(String formId) =>
      '$campos/findByFormId/$formId';
  static String removerCampo(String id) => '$campos/remover/$id';

  // Respostas
  static const String respostas = '/resposta';
  static String adicionarResposta() => '$respostas/add';
  static String removerResposta(String id) => '$respostas/remove/$id';
}

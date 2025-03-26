class Endpoints {
  static const String baseUrl = 'http://localhost:8080';

  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String perfil = '$baseUrl/perfil';

  static const String administradores = '$baseUrl/administradores';
  static String removerAdministrador(String id) =>
      '$administradores/$id/remover';

  static const String recrutadores = '$baseUrl/recrutadores';
  static String adicionarRecrutador(String adminId) =>
      '$recrutadores/$adminId/add';
  static String listarRecrutadoresPorAdmin(String adminId) =>
      '$recrutadores/$adminId/list';
  static String removerRecrutador(String id) => '$recrutadores/remover/$id';

  static const String formularios = '$baseUrl/formularios';
  static String adicionarFormulario(String adminId) =>
      '$formularios/add/$adminId';
  static String formularioPorId(String id) => '$formularios/$id';
  static String formulariosPorAdmin(String adminId) =>
      '$formularios/findByAdmin/$adminId';
  static String removerFormulario(String id) => '$formularios/remove/$id';

  static const String campos = '$baseUrl/campos';
  static String preencherCampo(String campoId) => '$campos/preencher/$campoId';
  static String adicionarCampo(String formId) => '$campos/add/$formId';
  static String camposPorFormulario(String formId) =>
      '$campos/findByFormId/$formId';
  static String removerCampo(String id) => '$campos/remover/$id';

  static const String respostas = '$baseUrl/resposta';
  static String adicionarResposta() => '$respostas/add';
  static String removerResposta(String id) => '$respostas/remove/$id';
}

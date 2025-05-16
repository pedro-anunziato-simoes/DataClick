export interface EntityCampo {
    campoTitulo: string;
    campoTipo: string;
    resposta: {
      tipo: string | number | boolean;
    };
    campoId: string;
  }
export interface EntityCampo {
    campoId:string
    titulo: string;
    tipo: string;
    resposta: {
      tipo: string | number | boolean;
    };
  }
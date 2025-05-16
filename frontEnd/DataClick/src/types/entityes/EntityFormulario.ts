import { EntityCampo } from "./EntityCampo"

export interface EntityFormulario {
    formularioTitulo:string
    formAdminId:string
    campos:EntityCampo[]
  }
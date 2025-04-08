import { EntityCampo } from "./EntityCampo"

export interface EntityFormulario {
    formId:string
    titulo:string
    adminId:string
    campos:EntityCampo[]
  }
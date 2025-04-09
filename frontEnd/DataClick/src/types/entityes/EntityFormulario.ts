import { EntityCampo } from "./EntityCampo"

export interface EntityFormulario {
    titulo:string
    adminId:string
    campos:EntityCampo[]
  }
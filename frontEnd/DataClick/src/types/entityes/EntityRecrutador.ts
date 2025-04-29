import { EntityFormulario } from "./EntityFormulario"

export interface EntityRecrutador {
   usuarioId:string
   adminId: string
   nome:String
   telefone:String
   email:String
   senha:string
   formularios:EntityFormulario[]
  }
import { EntityFormulario } from "./EntityFormulario"

export interface EntityRecrutador {
   nome:String
   telefone:String
   email:String
   senha:string
   formularios:EntityFormulario[]
  }
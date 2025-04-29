import { EntityFormulario } from "../EntityFormulario"

export interface RecrutadorCreateDTO {
   nome:String
   telefone:String
   email:String
   senha:string
   formularios:EntityFormulario[]
  }
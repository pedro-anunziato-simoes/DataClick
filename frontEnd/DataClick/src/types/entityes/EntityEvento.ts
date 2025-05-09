import { EntityFormulario } from "./EntityFormulario"

export interface EntityEvento {
    eventoId:string
    adminid:string
    eventoTitulo:string
    eventoDescricao:string
    eventoData:Date
    eventoFormularios:EntityFormulario[]
  }
import { EntityFormulario } from "./EntityFormulario"

export interface EntityEvento {
    idEvento:string
    adminid:string
    eventoTitulo:string
    eventoDescricao:string
    eventoData:Date
    eventoFormularios:EntityFormulario[]
  }
import { EntityFormulario } from "./EntityFormulario";
import { EntityRecrutador } from "./EntityRecrutador";

export interface EntityAdministrador {
    adminId:string
    cnpj: string,
    nome: string,
    senha: string,
    telefone: string,
    email: string,
    formularios:EntityFormulario[]
    recrutadores:EntityRecrutador[]
}
import { EntityEvento } from "./EntityEvento";
import { EntityFormulario } from "./EntityFormulario";
import { EntityRecrutador } from "./EntityRecrutador";

export interface EntityAdministrador {
    usuarioId:string
    cnpj: string,
    nome: string,
    senha: string,
    telefone: string,
    email: string,
    adminEventos:EntityEvento[]
    adminRecrutadores:EntityRecrutador[]
}
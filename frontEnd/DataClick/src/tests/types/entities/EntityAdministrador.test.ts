import { describe, it, expect, vi } from "vitest";
import { EntityRecrutador } from "../../../types/entityes/EntityRecrutador";
import { EntityAdministrador } from "../../../types/entityes/EntityAdministrador";
import { EntityEvento } from "../../../types/entityes/EntityEvento";

// Mock do evento
const mockEvento: EntityEvento = {
    eventoTitulo: "Evento de Teste",
    eventoData: new Date,
    eventoId: "",
    adminid: "",
    eventoDescricao: "",
    eventoFormularios: []
};

const mockRecrutador: EntityRecrutador = {
    usuarioId: "1",
    nome: "Recrutador Teste",
    adminId: "teste",
    telefone: '',
    email: '',
    senha: "",
    formularios: []
};

const mockAdministrador: EntityAdministrador = {
  usuarioId: "123",
  cnpj: "12345678000100",
  nome: "Administrador Teste",
  senha: "senha123",
  telefone: "11999999999",
  email: "admin@test.com",
  adminEventos: [mockEvento],
  adminRecrutadores: [mockRecrutador],
};

describe("EntityAdministrador", () => {
  it("deve conter as propriedades corretas de administrador", () => {
    // Verifica se o administrador tem a estrutura correta
    expect(mockAdministrador).toHaveProperty("usuarioId", "123");
    expect(mockAdministrador).toHaveProperty("cnpj", "12345678000100");
    expect(mockAdministrador).toHaveProperty("nome", "Administrador Teste");
    expect(mockAdministrador).toHaveProperty("email", "admin@test.com");
    expect(mockAdministrador).toHaveProperty("telefone", "11999999999");
    expect(mockAdministrador.adminEventos).toHaveLength(1);
    expect(mockAdministrador.adminRecrutadores).toHaveLength(1);
  });

  it("deve conter eventos e recrutadores relacionados", () => {
    // Verifica se os eventos e recrutadores estão corretamente relacionados
    expect(mockAdministrador.adminEventos[0].eventoTitulo).toBe("Evento de Teste");
    expect(mockAdministrador.adminRecrutadores[0].nome).toBe("Recrutador Teste");
  });

  it("não deve ter dados faltando", () => {
    // Verifica se todos os campos obrigatórios estão presentes
    expect(mockAdministrador.usuarioId).toBeDefined();
    expect(mockAdministrador.cnpj).toBeDefined();
    expect(mockAdministrador.nome).toBeDefined();
    expect(mockAdministrador.senha).toBeDefined();
    expect(mockAdministrador.telefone).toBeDefined();
    expect(mockAdministrador.email).toBeDefined();
    expect(mockAdministrador.adminEventos).toBeDefined();
    expect(mockAdministrador.adminRecrutadores).toBeDefined();
  });
});

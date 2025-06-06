import { describe, it, expect } from "vitest";
import { EntityCampo } from "../../../types/entityes/EntityCampo";


describe("EntityCampo", () => {
  const mockCampo: EntityCampo = {
    campoTitulo: "Título do Campo",
    campoTipo: "texto",
    resposta: {
      tipo: "string",
    },
    campoId: "campo123",
  };

  it("deve conter as propriedades corretas", () => {
    // Verifica se as propriedades estão presentes e corretas
    expect(mockCampo).toHaveProperty("campoTitulo", "Título do Campo");
    expect(mockCampo).toHaveProperty("campoTipo", "texto");
    expect(mockCampo).toHaveProperty("campoId", "campo123");
    expect(mockCampo.resposta).toHaveProperty("tipo", "string");
  });

  it("não deve ter propriedades faltando", () => {
    // Verifica se todas as propriedades necessárias estão presentes
    expect(mockCampo.campoTitulo).toBeDefined();
    expect(mockCampo.campoTipo).toBeDefined();
    expect(mockCampo.resposta).toBeDefined();
    expect(mockCampo.campoId).toBeDefined();
  });

  it("deve permitir diferentes tipos para 'resposta.tipo'", () => {
    // Verifica se 'resposta.tipo' pode ser um valor numérico, booleano ou string
    const campoNumerico: EntityCampo = {
      campoTitulo: "Campo Numérico",
      campoTipo: "numero",
      resposta: {
        tipo: 123,
      },
      campoId: "campo124",
    };

    const campoBooleano: EntityCampo = {
      campoTitulo: "Campo Booleano",
      campoTipo: "booleano",
      resposta: {
        tipo: true,
      },
      campoId: "campo125",
    };

    expect(campoNumerico.resposta.tipo).toBe(123);
    expect(campoBooleano.resposta.tipo).toBe(true);
  });
});

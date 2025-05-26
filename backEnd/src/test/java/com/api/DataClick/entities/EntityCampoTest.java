package com.api.DataClick.entities;

import com.api.DataClick.enums.TipoCampo;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class EntityCampoTest {

    private EntityCampo campo;
    private final String TITULO = "Campo de Teste";
    private final TipoCampo TIPO = TipoCampo.TEXTO;

    @BeforeEach
    void setUp() {
        campo = new EntityCampo(TITULO, TIPO, null );
    }

    @Test
    void getCampoId_DeveRetornarIdCorreto() {
        String expectedId = "12345";
        campo.setCampoId(expectedId);

        String actualId = campo.getCampoId();

        assertEquals(expectedId, actualId, "O ID do campo deve ser igual ao configurado");
    }

    @Test
    void getCampoResposta_DeveRetornarRespostaCorreta() {
        Object expectedResposta = "Resposta de teste";
        campo.setResposta(expectedResposta);

        Object actualResposta = campo.getResposta();

        assertEquals(expectedResposta, actualResposta, "A resposta deve ser igual à configurada");
    }

    @Test
    void setCampoResposta_DeveArmazenarDiferentesTiposDeDados() {
        assertAll(
                () -> {
                    Object resposta1 = "Texto simples";
                    campo.setResposta(resposta1);
                    assertEquals(resposta1, campo.getResposta());
                },

                () -> {
                    Object resposta2 = 42;
                    campo.setResposta(resposta2);
                    assertEquals(resposta2, campo.getResposta());
                },

                () -> {

                    Object resposta3 = new Object() {
                        @Override
                        public String toString() {
                            return "Objeto customizado";
                        }
                    };
                    campo.setResposta(resposta3);
                    assertEquals(resposta3.toString(), campo.getResposta().toString());
                },

                () -> {
                    campo.setResposta(null);
                    assertNull(campo.getResposta());
                }
        );
    }

    @Test
    void setCampoResposta_DeveManterEstadoAnteriorAteAtualizacao() {
        Object primeiraResposta = "Primeira resposta";
        Object segundaResposta = 123.45;

        campo.setResposta(primeiraResposta);
        assertEquals(primeiraResposta, campo.getResposta());

        campo.setResposta(segundaResposta);
        assertEquals(segundaResposta, campo.getResposta());
        assertNotEquals(primeiraResposta, campo.getResposta());
    }
}

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
        campo = new EntityCampo(TITULO, TIPO,new Object());
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
        campo.setCampoResposta(expectedResposta);

        Object actualResposta = campo.getCampoResposta();

        assertEquals(expectedResposta, actualResposta, "A resposta deve ser igual à configurada");
    }

    @Test
    void setCampoResposta_DeveArmazenarDiferentesTiposDeDados() {
        assertAll(
                () -> {
                    Object resposta1 = "Texto simples";
                    campo.setCampoResposta(resposta1);
                    assertEquals(resposta1, campo.getCampoResposta());
                },

                () -> {
                    Object resposta2 = 42;
                    campo.setCampoResposta(resposta2);
                    assertEquals(resposta2, campo.getCampoResposta());
                },

                () -> {

                    Object resposta3 = new Object() {
                        @Override
                        public String toString() {
                            return "Objeto customizado";
                        }
                    };
                    campo.setCampoResposta(resposta3);
                    assertEquals(resposta3.toString(), campo.getCampoResposta().toString());
                },

                () -> {
                    campo.setCampoResposta(null);
                    assertNull(campo.getCampoResposta());
                }
        );
    }

    @Test
    void setCampoResposta_DeveManterEstadoAnteriorAteAtualizacao() {
        Object primeiraResposta = "Primeira resposta";
        Object segundaResposta = 123.45;

        campo.setCampoResposta(primeiraResposta);
        assertEquals(primeiraResposta, campo.getCampoResposta());

        campo.setCampoResposta(segundaResposta);
        assertEquals(segundaResposta, campo.getCampoResposta());
        assertNotEquals(primeiraResposta, campo.getCampoResposta());
    }
}

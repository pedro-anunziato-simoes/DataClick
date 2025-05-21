package com.api.DataClick.DTO;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class RecrutadorDTOTest {

    @Test
    void getRecrutadorSenhaDto_DeveRetornarSenhaCorreta() {
        RecrutadorDTO dto = new RecrutadorDTO();
        String senhaEsperada = "senhaSegura123@";

        dto.setRecrutadorSenhaDto(senhaEsperada);
        String senhaRetornada = dto.getRecrutadorSenhaDto();

        assertEquals(senhaEsperada, senhaRetornada, "A senha retornada deve ser igual à configurada");
    }
}

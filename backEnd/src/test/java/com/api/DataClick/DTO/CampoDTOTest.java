package com.api.DataClick.DTO;

import com.api.DataClick.enums.TipoCampo;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertAll;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class CampoDTOTest {
    @Test
    void deveConfigurarERetornarValoresCorretamente() {
        CampoDTO dto = new CampoDTO();

        dto.setCampoTituloDto("Idade");
        dto.setCampoTipoDto(TipoCampo.NUMERO);

        assertAll(
                () -> assertEquals("Idade", dto.getCampoTituloDto()),
                () -> assertEquals(TipoCampo.NUMERO, dto.getCampoTipoDto())
        );
    }
}

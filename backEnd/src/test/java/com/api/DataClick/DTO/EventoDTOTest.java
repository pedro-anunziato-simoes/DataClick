package com.api.DataClick.DTO;

import org.junit.jupiter.api.Test;

import java.util.Date;

import static org.junit.jupiter.api.Assertions.assertAll;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class EventoDTOTest {

    @Test
    void deveConfigurarERetornarValoresCorretamente() {

        Date dataTeste = new Date();
        EventoDTO dto = new EventoDTO();

        dto.setEventoTituloDto("Workshop Spring Boot");
        dto.setEventoDescricaoDto("Evento sobre desenvolvimento API REST");
        dto.setEventoDataDto(dataTeste);

        assertAll(
                () -> assertEquals("Workshop Spring Boot", dto.getEventoTituloDto()),
                () -> assertEquals("Evento sobre desenvolvimento API REST", dto.getEventoDescricaoDto()),
                () -> assertEquals(dataTeste, dto.getEventoDataDto())
        );
    }
}

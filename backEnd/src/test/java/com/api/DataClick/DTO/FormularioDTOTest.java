package com.api.DataClick.DTO;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class FormularioDTOTest {

    @Test
    void deveConfigurarERetornarTituloCorretamente() {
        FormularioDTO dto = new FormularioDTO();

        dto.setFormularioTituloDto("Cadastro de Desenvolvedores");

        assertEquals("Cadastro de Desenvolvedores", dto.getFormularioTituloDto());
    }
}

package com.api.DataClick.DTO;


import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class FormularioDTO {
    private String formularioTituloDto;

    public String getFormularioTituloDto() {
        return formularioTituloDto;
    }

    public void setFormularioTituloDto(String formularioTituloDto) {
        this.formularioTituloDto = formularioTituloDto;
    }
}

package com.api.DataClick.DTO;

import com.api.DataClick.enums.TipoCampo;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CampoDTO {
    private TipoCampo campoTipoDto;
    private String campoTituloDto;

    public TipoCampo getCampoTipoDto() {
        return campoTipoDto;
    }

    public String getCampoTituloDto() {
        return campoTituloDto;
    }

    public void setCampoTipoDto(TipoCampo campoTipoDto) {
        this.campoTipoDto = campoTipoDto;
    }

    public void setCampoTituloDto(String campoTituloDto) {
        this.campoTituloDto = campoTituloDto;
    }
}

package com.api.DataClick.DTO;

import com.api.DataClick.enums.TipoCampo;

public class CampoDTO {
    private TipoCampo campoTipoDto;
    private String campoTituloDto;

    public TipoCampo getCampoTipoDto() {
        return campoTipoDto;
    }

    public String getCampoTituloDto() {
        return campoTituloDto;
    }
}

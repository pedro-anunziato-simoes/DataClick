package com.api.DataClick.DTO;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;


@Getter
@Setter
public class EventoDTO {
    private String eventoTituloDto;
    private String eventoDescricaoDto;
    private Date eventoDataDto;

    public String getEventoTituloDto() {
        return eventoTituloDto;
    }

    public String getEventoDescricaoDto() {
        return eventoDescricaoDto;
    }

    public Date getEventoDataDto() {
        return eventoDataDto;
    }
}

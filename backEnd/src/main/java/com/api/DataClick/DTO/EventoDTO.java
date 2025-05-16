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

    public void setEventoTituloDto(String eventoTituloDto) {
        this.eventoTituloDto = eventoTituloDto;
    }

    public void setEventoDescricaoDto(String eventoDescricaoDto) {
        this.eventoDescricaoDto = eventoDescricaoDto;
    }

    public void setEventoDataDto(Date eventoDataDto) {
        this.eventoDataDto = eventoDataDto;
    }
}

package com.api.DataClick.DTO;

import java.util.Date;

public class EventoUpdateDTO {
    private String titulo;
    private String descricao;
    private Date data;

    public String getTituloEventoDTO() {
        return titulo;
    }

    public String getDescricaoEventoDTO() {
        return descricao;
    }

    public Date getDataEventoDTO() {
        return data;
    }
}

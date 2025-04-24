package com.api.DataClick.DTO;

public class FormularioUpdateDTO {
    private String titulo;

    public FormularioUpdateDTO(String titulo) {
        this.titulo = titulo;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }
}

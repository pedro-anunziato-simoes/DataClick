package com.api.DataClick.entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;

import java.util.List;

public class EntityFormulario {
    @Id
    private String id;
    private String titulo;
    @DBRef
    private EntityAdministrador administrador;
    private List<String> campos;

    public EntityFormulario(EntityAdministrador administrador, List<String> campos,String titulo) {
        this.titulo = titulo;
        this.administrador = administrador;
        this.campos = campos;
    }

    public String getId() {
        return id;
    }

    public EntityAdministrador getAdministrador() {
        return administrador;
    }

    public void setAdministrador(EntityAdministrador administrador) {
        this.administrador = administrador;
    }

    public List<String> getCampos() {
        return campos;
    }

    public void setCampos(List<String> campos) {
        this.campos = campos;
    }

    public String getTitulo() { return titulo; }

    public void setTitulo(String titulo) { this.titulo = titulo; }
}

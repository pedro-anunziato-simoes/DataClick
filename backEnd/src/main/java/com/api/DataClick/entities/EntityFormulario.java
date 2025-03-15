package com.api.DataClick.entities;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.List;

@Data
@Document(collection = "Formularios")
public class EntityFormulario {

    @Id
    private String id;
    private String titulo;
    private String adminId;
    private List<String> recrutadorId;
    @DBRef
    private List<EntityCampo> campos = new ArrayList<>();

    public EntityFormulario(String id, String adminId, String titulo, List<String> recrutadorId) {
        this.id = id;
        this.adminId = adminId;
        this.titulo = titulo;
        this.recrutadorId = recrutadorId;
    }

    public String getId() {
        return id;
    }

    public String getAdminId() {
        return adminId;
    }

    public void setAdminId(String adminId) {
        this.adminId = adminId;
    }

    public List<EntityCampo> getCampos() {
        return campos;
    }

    public void setCampos(List<EntityCampo> campos) {
        this.campos = campos;
    }

    public String getTitulo() { return titulo; }

    public void setTitulo(String titulo) { this.titulo = titulo; }
}

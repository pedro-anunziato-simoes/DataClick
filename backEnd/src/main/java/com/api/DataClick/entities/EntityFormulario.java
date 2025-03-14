package com.api.DataClick.entities;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Data
@Document(collection = "Formularios")
public class EntityFormulario {

    @Id
    private String id;
    private String titulo;
    private String adminId;
    private List<EntityCampos> campos;

    public EntityFormulario(String id, String adminId, List<EntityCampos> campos, String titulo) {
        this.id = id;
        this.adminId = adminId;
        this.titulo = titulo;
        this.campos = campos;
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

    public List<EntityCampos> getCampos() {
        return campos;
    }

    public void setCampos(List<EntityCampos> campos) {
        this.campos = campos;
    }

    public String getTitulo() { return titulo; }

    public void setTitulo(String titulo) { this.titulo = titulo; }
}

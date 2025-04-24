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
    private String formId;
    private String titulo;
    private String adminId;
    @DBRef
    private List<EntityCampo> campos = new ArrayList<>();

    public EntityFormulario( String adminId, String titulo) {
        this.adminId = adminId;
        this.titulo = titulo;
    }

    public String getId() {
        return formId;
    }

    public void setTituloForm(String titulo) {
        this.titulo = titulo;
    }
}

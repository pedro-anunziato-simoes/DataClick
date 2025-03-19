package com.api.DataClick.entities;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "Respostas")
public class EntityResposta {
    @Id
    private String id;
    private EntityFormulario formulario;

    public EntityResposta(EntityFormulario formulario) {
        this.formulario = formulario;
    }

    public String getId() {
        return id;
    }

    public EntityFormulario getFormulario() {
        return formulario;
    }

    public void setFormulario(EntityFormulario formulario) {
        this.formulario = formulario;
    }

}
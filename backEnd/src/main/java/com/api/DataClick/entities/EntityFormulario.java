package com.api.DataClick.entities;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Data
@Document(collection = "Formularios")
public class EntityFormulario {

    @Id
    private String formId;
    private String titulo;
    private String formAdminId;
    @DBRef
    private List<EntityCampo> campos = new ArrayList<>();

    public EntityFormulario( String adminId, String titulo) {
        this.formAdminId = adminId;
        this.titulo = titulo;
    }

    public String getFormId() {
     return formId;
  }

    public String getFormularioTitulo() {
        return titulo;
    }

    public void setFomularioTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getFormAdminId() {
        return formAdminId;
    }

    public void setFormAdminId(String formAdminId) {
        this.formAdminId = formAdminId;
    }

    public List<EntityCampo> getCampos() {
        return campos;
    }
}

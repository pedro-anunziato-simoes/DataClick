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
    private String formularioTitulo;
    private String formAdminId;
    private String formularioEventoId;
    private List<EntityCampo> campos;

    public EntityFormulario(String formularioTitulo, String formAdminId, String formularioEventoId, List<EntityCampo> campos) {
        this.formularioTitulo = formularioTitulo;
        this.formAdminId = formAdminId;
        this.formularioEventoId = formularioEventoId;
        this.campos = campos;
    }

    public String getFormularioEventoId() {
        return formularioEventoId;
    }

    public void setFormularioEventoId(String formularioEventoId) {
        this.formularioEventoId = formularioEventoId;
    }

    public String getFormId() {
     return formId;
  }

    public String getFormularioTitulo() {
        return formularioTitulo;
    }

    public void setFomularioTitulo(String formularioTitulo) {
        this.formularioTitulo = formularioTitulo;
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

    public void setFormId(String formId) {
        this.formId = formId;
    }

    public void setFormularioTitulo(String formularioTitulo) {
        this.formularioTitulo = formularioTitulo;
    }

    public void setCampos(List<EntityCampo> campos) {
        this.campos = campos;
    }
}

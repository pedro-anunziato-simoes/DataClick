package com.api.DataClick.entities;

import lombok.Data;
import lombok.Getter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Getter
@Data
@Document(collection = "FormulariosPreenchidos")
public class EntityFormulariosPreenchidos {

    @Id
    private String FormulariosPreId;
    private String formularioPreenchidoEventoId;
    private List<EntityFormulario> formularioPreenchidoListaFormularios;

    public EntityFormulariosPreenchidos(String formularioPreenchidoEventoId, List<EntityFormulario> formularioPreenchidoListaFormularios) {
        this.formularioPreenchidoEventoId = formularioPreenchidoEventoId;
        this.formularioPreenchidoListaFormularios = formularioPreenchidoListaFormularios;
    }

    public List<EntityFormulario> getFormularioPreenchidoListaFormularios() {
        return formularioPreenchidoListaFormularios;
    }

    public String getFormularioPreenchidoEventoId() {
        return formularioPreenchidoEventoId;
    }

    public void setFormularioPreenchidoEventoId(String formularioPreenchidoEventoId) {
        this.formularioPreenchidoEventoId = formularioPreenchidoEventoId;
    }

    public void setFormularioPreenchidoListaFormularios(List<EntityFormulario> formularioPreenchidoListaFormularios) {
        this.formularioPreenchidoListaFormularios = formularioPreenchidoListaFormularios;
    }

    public void setFormulariosPreId(String formulariosPreId) {
        FormulariosPreId = formulariosPreId;
    }
}


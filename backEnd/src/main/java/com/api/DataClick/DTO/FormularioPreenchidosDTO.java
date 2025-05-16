package com.api.DataClick.DTO;

import com.api.DataClick.entities.EntityFormulario;

import java.util.List;

public class FormularioPreenchidosDTO {
    private List<EntityFormulario> formulariosPreenchidosDtoListForms;

    public List<EntityFormulario> getFormulariosPreenchidosDtoListForms() {
        return formulariosPreenchidosDtoListForms;
    }

    public void setFormulariosPreenchidosDtoListForms(List<EntityFormulario> formulariosPreenchidosDtoListForms) {
        this.formulariosPreenchidosDtoListForms = formulariosPreenchidosDtoListForms;
    }
}

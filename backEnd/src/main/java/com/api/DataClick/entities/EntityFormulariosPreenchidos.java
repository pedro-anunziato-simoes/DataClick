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
    private String recrutadorId;
    private String adminId;
    private List<EntityFormulario> listaFormularios;

    public EntityFormulariosPreenchidos(List<EntityFormulario> listaFormularios) {
        this.listaFormularios = listaFormularios;
    }
}

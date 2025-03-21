package com.api.DataClick.entities;

import lombok.Data;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Data
@Document(collection = "Recrutadores")
public class EntityRecrutador extends Usuario{

    private String adminId;
    @DBRef
    private List<EntityFormulario> formularios;

    public EntityRecrutador(String nome, String email, String telefone,String adminId,List<EntityFormulario> formularios) {
        super(null, nome, email, telefone);
        this.adminId = adminId;
        this.formularios = formularios;
    }
}

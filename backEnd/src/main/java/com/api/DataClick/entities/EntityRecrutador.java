package com.api.DataClick.entities;

import com.api.DataClick.enums.UserRole;
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

    public EntityRecrutador(
            String nome,
            String senha,
            String telefone,
            String email,
            String adminId,
            List<EntityFormulario> formularios,
            UserRole role
    ) {
        super(null, nome, senha, telefone, email, role);
        this.adminId = adminId;
        this.formularios = formularios;
    }
}

package com.api.DataClick.entities;

import com.api.DataClick.enums.UserRole;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Calendar;
import java.util.List;

@Getter
@Setter
@Data
@Document(collection = "Recrutadores")
public class EntityRecrutador extends Usuario{

    private String adminId;
    @DBRef
    private List<EntityEvento> eventos;


    public EntityRecrutador(
            String nome,
            String senha,
            String telefone,
            String email,
            String adminId,
            List<EntityEvento> eventos,
            UserRole role
    ) {
        super(null, nome, senha, telefone, email, role);
        this.adminId = adminId;
        this.eventos = eventos;
    }

    public String getRecrutadorAdminId() {
        return adminId;
    }

    public List<EntityEvento> getRecrutadorEventos() {
        return eventos;
    }

    public String getAdminId() {
        return adminId;
    }


    public List<EntityFormulario> getFormularios() {
        return formularios;
    }
}

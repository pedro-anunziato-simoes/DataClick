package com.api.DataClick.entities;

import com.api.DataClick.enums.UserRole;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.security.core.GrantedAuthority;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Data
@Document(collection = "Administradores")
public class EntityAdministrador extends Usuario{

    @Setter
    private String cnpj;

    @DBRef
    private List<EntityRecrutador> recrutadores = new ArrayList<>();
    @DBRef
    private List<EntityFormulario> formularios = new ArrayList<>();


    public EntityAdministrador
            (String cnpj,
             String nome,
             String senha,
             String telefone,
             String email,
             UserRole role
            ) {
        super(null, nome, senha, telefone, email, role);
        this.cnpj = cnpj;
    }



    public String getCnpj() {
        return cnpj;
    }

    public List<EntityRecrutador> getRecrutadores() {
        return recrutadores;
    }

    public void setRecrutadores(List<EntityRecrutador> recrutadores) {
        this.recrutadores = this.recrutadores;
    }

    public List<EntityFormulario> getFormularios() {
        return formularios;
    }


}

package com.api.DataClick.entities;

import com.api.DataClick.enums.UserRole;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.security.core.GrantedAuthority;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;


@Data
@Document(collection = "Administradores")
@Getter
@Setter
public class EntityAdministrador extends Usuario{

    @Setter
    private String cnpj;
    @DBRef
    private List<EntityRecrutador> recrutadores = new ArrayList<>();
    @DBRef
    private List<EntityEvento> eventos = new ArrayList<>();


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

    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }

    public List<EntityRecrutador> getAdminRecrutadores() {
        return recrutadores;
    }

    public List<EntityEvento> getAdminEventos() {
        return eventos;
    }
}

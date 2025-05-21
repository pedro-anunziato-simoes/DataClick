package com.api.DataClick.entities;

import com.api.DataClick.DTO.FormularioPreenchidosDTO;
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
    private List<EntityRecrutador> adminRecrutadores = new ArrayList<>();
    @DBRef
    private List<EntityEvento> adminEventos = new ArrayList<>();
    private List<EntityFormulariosPreenchidos> adminFormsPreenchidos = new ArrayList<>();


    public EntityAdministrador
            (String cnpj,
             String nome,
             String senha,
             String telefone,
             String email,
             UserRole role
            ) {
        super(nome, senha, telefone, email, role);
        this.cnpj = cnpj;
    }
    public String getCnpj() {
        return cnpj;
    }

    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }

    public void setAdminRecrutadores(List<EntityRecrutador> adminRecrutadores) {
        this.adminRecrutadores = adminRecrutadores;
    }

    public void setAdminEventos(List<EntityEvento> adminEventos) {
        this.adminEventos = adminEventos;
    }

    public List<EntityFormulariosPreenchidos> getAdminFormsPreenchidos() {
        return adminFormsPreenchidos;
    }

    public void setAdminFormsPreenchidos(List<EntityFormulariosPreenchidos> adminFormsPreenchidos) {
        this.adminFormsPreenchidos = adminFormsPreenchidos;
    }

    public List<EntityRecrutador> getAdminRecrutadores() {
        return adminRecrutadores;
    }

    public List<EntityEvento> getAdminEventos() {
        return adminEventos;
    }
}

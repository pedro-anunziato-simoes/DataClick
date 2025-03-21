package com.api.DataClick.entities;

import lombok.Data;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.List;

@Data
@Document(collection = "Administradores")
public class EntityAdministrador extends Usuario{

    @Setter
    private String cnpj;
    private String senha;
    @DBRef
    private List<EntityRecrutador> recrutadores = new ArrayList<>();
    @DBRef
    private List<EntityFormulario> formularios = new ArrayList<>();


    public EntityAdministrador(String cnpj, String nome, String email, String senha, String telefone) {
        super(null, nome, email,telefone);
        this.senha = senha;
        this.cnpj = cnpj;
    }

    public String getSenha() {
        return senha;
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

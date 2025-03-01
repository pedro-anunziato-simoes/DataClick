package com.api.DataClick.entities;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Data
@Document(collection = "Administradores")
public class EntityAdministrador {

    @Id
    private String id;
    private String cnpj;
    private String senha;
    private String email;
    private String telefone;
    private List<EntityRecrutador> listaRecrutadores;

    public EntityAdministrador(String cnpj, String senha, String email, String telefone,List<EntityRecrutador> listaRecrutadores) {
        this.cnpj = cnpj;
        this.senha = senha;
        this.email = email;
        this.telefone = telefone;
        this.listaRecrutadores = listaRecrutadores;
    }

    public String getId() {
        return id;
    }

    public String getCnpj() {
        return cnpj;
    }

    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    public List<EntityRecrutador> getListaRecrutadores() {
        return listaRecrutadores;
    }

    public void setListaRecrutadores(List<EntityRecrutador> listaRecrutadores) {
        this.listaRecrutadores = listaRecrutadores;
    }
}

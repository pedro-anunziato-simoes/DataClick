package com.api.DataClick.entities;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "administradores")
public class Administrador {

    @Id
    private Long id;
    private String cnpj;
    private String senha;
    private String email;
    private String telefone;

    public Administrador() {
    }

    public Administrador(String telefone, String email, String senha, String cnpj) {
        this.telefone = telefone;
        this.email = email;
        this.senha = senha;
        this.cnpj = cnpj;
    }

    public Long getId() {
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
}

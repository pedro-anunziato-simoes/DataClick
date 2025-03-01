package com.API.DataClick.entities;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "Recrutadores")
public class EntityRecrutador {

    @Id
    private String id;
    private String nome;
    private String email;
    private String telefone;
    private String token;
    @DBRef
    private EntityAdministrador administrador;

    public EntityRecrutador(String nome, String email, String telefone, String token, EntityAdministrador administrador) {
        this.nome = nome;
        this.email = email;
        this.telefone = telefone;
        this.token = token;
        this.administrador = administrador;
    }

    public String getId() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
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

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public EntityAdministrador getAdministrador() {
        return administrador;
    }

    public void setAdministrador(EntityAdministrador administrador) {
        this.administrador = administrador;
    }
}

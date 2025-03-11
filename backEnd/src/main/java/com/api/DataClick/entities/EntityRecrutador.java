package com.api.DataClick.entities;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "Recrutadores")
public class EntityRecrutador extends Usuario{

    private String token;

    public EntityRecrutador(String nome, String email, String senha, String telefone, String token) {
        super(null, nome, email, senha, telefone);
        this.token = token;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

}

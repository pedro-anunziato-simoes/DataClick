package com.api.DataClick.entities;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "formularios")
public class Formulario {

    @Id
    private String id;
    private String campo;

    public Formulario() {
    }

    public Formulario(String campo) {
        this.campo = campo;
    }

    public String getId() {
        return id;
    }

    public String getCampo() {
        return campo;
    }

    public void setCampo(String campo) {
        this.campo = campo;
    }
}

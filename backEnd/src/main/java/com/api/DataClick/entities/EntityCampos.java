package com.api.DataClick.entities;

import lombok.Data;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "Campos")
public class EntityCampos {

    private String titulo;
    private String resposta;

    public EntityCampos(String titulo, String resposta) {
        this.titulo = titulo;
        this.resposta = resposta;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getResposta() {
        return resposta;
    }

    public void setResposta(String resposta) {
        this.resposta = resposta;
    }
}

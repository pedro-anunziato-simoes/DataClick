package com.api.DataClick.entities;


import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "Campos")
public class EntityCampo {

    @Id
    private String id;
    private String titulo;
    private String resposta;

    public EntityCampo(String titulo, String resposta) {
        this.titulo = titulo;
        this.resposta = resposta;
    }

    public String getId() {
        return id;
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

    public void setResposta(String reposta) {
        this.resposta = reposta;
    }
}

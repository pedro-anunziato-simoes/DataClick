package com.api.DataClick.entities;


import com.api.DataClick.enums.TipoCampo;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "Campos")
public class EntityCampo {

    @Id
    private String id;
    private String titulo;
    private TipoCampo tipo;
    private EntityResposta resposta;

    public EntityCampo(String titulo, TipoCampo tipo, EntityResposta resposta) {
        this.titulo = titulo;
        this.tipo = tipo;
        this.resposta = resposta;
    }

    public EntityResposta getResposta() {
        return resposta;
    }

    public TipoCampo getTipo() {
        return tipo;
    }

    public String getId() {
        return id;
    }

    public String getTitulo() {
        return titulo;
    }

}

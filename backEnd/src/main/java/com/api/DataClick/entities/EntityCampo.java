package com.api.DataClick.entities;


import com.api.DataClick.enums.TipoCampo;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Getter
@Setter
@Data
@Document(collection = "Campos")
public class EntityCampo {

    @Id
    private String campoId;
    private String formId;
    private String titulo;
    private TipoCampo tipo;
    private Object resposta;

    public EntityCampo(String titulo, TipoCampo tipo) {
        this.titulo = titulo;
        this.tipo = tipo;
    }

    public String getCampoId() {
        return campoId;
    }

    public String getCampoFormId() {
        return formId;
    }

    public void setCampoFormId(String formId) {
        this.formId = formId;
    }

    public String getCampoTitulo() {
        return titulo;
    }

    public void setCampoTitulo(String titulo) {
        this.titulo = titulo;
    }

    public TipoCampo getCampoTipo() {
        return tipo;
    }

    public void setCampoTipo(TipoCampo tipo) {
        this.tipo = tipo;
    }

    public Object getCampoResposta() {
        return resposta;
    }

    public void setCampoResposta(Object resposta) {
        this.resposta = resposta;
    }

}

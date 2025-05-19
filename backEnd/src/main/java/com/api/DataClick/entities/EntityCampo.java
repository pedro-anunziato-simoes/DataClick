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
    private String campoFormId;
    private String campoTitulo;
    private TipoCampo campoTipo;
    private Object resposta;

    public EntityCampo(String campoTitulo, TipoCampo campoTipo, Object resposta) {
        this.campoTitulo = campoTitulo;
        this.campoTipo = campoTipo;
        this.resposta = resposta;
    }

    public String getCampoFormId() {
        return campoFormId;
    }

    public void setCampoFormId(String campoFormId) {
        this.campoFormId = campoFormId;
    }

    public String getCampoTitulo() {
        return campoTitulo;
    }

    public void setCampoTitulo(String campoTitulo) {
        this.campoTitulo = campoTitulo;
    }

    public TipoCampo getCampoTipo() {
        return campoTipo;
    }

    public void setCampoTipo(TipoCampo campoTipo) {
        this.campoTipo = campoTipo;
    }

    public Object getCampoResposta() {
        return resposta;
    }

    public void setCampoResposta(Object resposta) {
        this.resposta = resposta;
    }

    public void setCampoId(String campoId) {
        this.campoId = campoId;
    }

    public String getCampoId() {
        return campoId;
    }
}

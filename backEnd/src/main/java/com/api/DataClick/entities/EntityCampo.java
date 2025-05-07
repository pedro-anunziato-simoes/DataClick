package com.api.DataClick.entities;


import com.api.DataClick.enums.TipoCampo;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

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

    public void setFormId(String idForm) {
        this.formId = idForm;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public TipoCampo getTipo() {
        return tipo;
    }

    public void setTipo(TipoCampo tipo) {
        this.tipo = tipo;
    }
}

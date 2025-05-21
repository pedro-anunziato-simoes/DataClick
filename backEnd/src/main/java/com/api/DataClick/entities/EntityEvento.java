package com.api.DataClick.entities;

import lombok.Data;
import lombok.Generated;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@Data
@Document(collection = "Eventos")
@Generated
public class EntityEvento {

    @Id
    private String eventoId;
    private String eventoAdminId;
    private String eventoTitulo;
    private String eventoDescricao;
    private Date eventoData;
    @DBRef
    private List<EntityFormulario> eventoFormularios;

    public EntityEvento(String eventoAdminId, String eventoTitulo, String eventoDescricao, Date eventoData, List<EntityFormulario> eventoFormularios) {
        this.eventoAdminId = eventoAdminId;
        this.eventoTitulo = eventoTitulo;
        this.eventoDescricao = eventoDescricao;
        this.eventoData = eventoData;
        this.eventoFormularios = eventoFormularios;
    }

    public String getEventoAdminId() {
        return eventoAdminId;
    }

    public void setEventoAdminId(String eventoAdminId) {
        this.eventoAdminId = this.eventoAdminId;
    }

    public String getEventoTitulo() {
        return eventoTitulo;
    }

    public void setEventoTitulo(String eventoTitulo) {
        this.eventoTitulo = eventoTitulo;
    }

    public String getEventoDescricao() {
        return eventoDescricao;
    }

    public void setEventoDescricao(String eventoDescricao) {
        this.eventoDescricao = eventoDescricao;
    }

    public Date getEventoData() {
        return eventoData;
    }

    public void setEventoData(Date eventoData) {
        this.eventoData = eventoData;
    }

    public List<EntityFormulario> getEventoFormularios() {
        return eventoFormularios;
    }

    public void setEventoFormularios(List<EntityFormulario> formularios) {
        this.eventoFormularios = formularios;
    }

    public void setEventoId(String eventoId) {
        this.eventoId = eventoId;
    }
}

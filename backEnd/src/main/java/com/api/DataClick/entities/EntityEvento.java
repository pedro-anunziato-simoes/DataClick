package com.api.DataClick.entities;

import lombok.Data;
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
public class EntityEvento {

    @Id
    private String idEvento;
    @DBRef
    private String adminId;
    private String eventoTitulo;
    private String eventoDescricao;
    private Date data;
    @DBRef
    private List<EntityFormulario> formularios;

    public EntityEvento(String adminId, String titulo, String descricao, Date data, List<EntityFormulario> formularios) {
        this.adminId = adminId;
        this.eventoTitulo = titulo;
        this.eventoDescricao = descricao;
        this.data = data;
        this.formularios = formularios;
    }

    public String getEventoAdminId() {
        return adminId;
    }

    public void setEventoAdminId(String adminId) {
        this.adminId = adminId;
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
        return data;
    }

    public void setEventoData(Date data) {
        this.data = data;
    }

    public List<EntityFormulario> getEventoFormularios() {
        return formularios;
    }

    public void setEventoFormularios(List<EntityFormulario> formularios) {
        this.formularios = formularios;
    }
}

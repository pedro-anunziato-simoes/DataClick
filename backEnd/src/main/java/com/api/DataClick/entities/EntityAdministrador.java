package com.api.DataClick.entities;

import lombok.Data;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;

@Data
@Document(collection = "Administradores")
public class EntityAdministrador extends Usuario{

    @Setter
    private String cnpj;
    @DBRef
    private List<EntityRecrutador> listaRecrutadores = new ArrayList<>();

    public EntityAdministrador() {
    }

    public EntityAdministrador(String cnpj, String nome, String email, String senha, String telefone, List<EntityRecrutador> listaRecrutadores) {
        super(null, nome, email, senha, telefone);
        this.cnpj = cnpj;
        this.listaRecrutadores = listaRecrutadores;
    }


    public String getCnpj() {
        return cnpj;
    }

    public List<EntityRecrutador> getListaRecrutadores() {
        return listaRecrutadores;
    }

    public void setListaRecrutadores(List<EntityRecrutador> listaRecrutadores) {
        this.listaRecrutadores = listaRecrutadores;
    }
}

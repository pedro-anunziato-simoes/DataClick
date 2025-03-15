package com.api.DataClick.services;

import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryFormulario;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

@Service
public class ServiceRecrutador {

    @Autowired
    private RepositoryFormulario repositoryFormulario;
    @Autowired
    private RepositoryAdministrador repositoryAdministrador;
    @Autowired
    private RepositoryRecrutador repositoryRecrutador;


    public List<EntityRecrutador> listarTodosRecrutadores(){
        return repositoryRecrutador.findAll();
    }

    public EntityRecrutador criarRecrutador(String administradorId, EntityRecrutador recrutador) {
        EntityAdministrador administrador = repositoryAdministrador.findById(administradorId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Administrador não encontrado"));
        repositoryRecrutador.save(recrutador);
        recrutador.setAdminId(administradorId);
        repositoryRecrutador.save(recrutador);
        administrador.getRecrutadores().add(recrutador);
        repositoryAdministrador.save(administrador);
        return recrutador;
    }

    public void removerRecrutador(String recrutadorId) {
        repositoryRecrutador.deleteById(recrutadorId);
    }


    public List<EntityRecrutador> listarRecrutadores(String administradorId) {
        EntityAdministrador administrador = repositoryAdministrador.findById(administradorId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Administrador não encontrado"));

        return administrador.getRecrutadores();
    }

    /*
    public ?? preencherFormualrio(String formularioId){

    }
    */
}

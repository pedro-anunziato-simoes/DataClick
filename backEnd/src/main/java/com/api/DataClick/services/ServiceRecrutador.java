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


    public EntityRecrutador criarRecrutador(String administradorId, EntityRecrutador recrutador) {
        EntityAdministrador administrador = repositoryAdministrador.findById(administradorId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Administrador não encontrado"));

        if (administrador.getRecrutadores().stream().anyMatch(r -> r.getId().equals(recrutador.getId()))) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Recrutador já está vinculado a este administrador");
        }

        EntityRecrutador recrutadorSalvo = repositoryRecrutador.save(recrutador);
        recrutadorSalvo.setAdminId(administradorId);
        administrador.getRecrutadores().add(recrutadorSalvo);
        repositoryAdministrador.save(administrador);
        return recrutadorSalvo;
    }

    public void removerRecrutador(String administradorId, String recrutadorId) {
        EntityAdministrador administrador = repositoryAdministrador.findById(administradorId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Administrador não encontrado"));

        EntityRecrutador recrutador = administrador.getRecrutadores().stream()
                .filter(r -> r.getId().equals(recrutadorId))
                .findFirst()
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Recrutador não encontrado ou não vinculado a este administrador"));

        administrador.getRecrutadores().remove(recrutador);
        repositoryAdministrador.save(administrador);
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

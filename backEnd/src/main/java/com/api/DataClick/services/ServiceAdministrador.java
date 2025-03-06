package com.api.DataClick.services;

import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

@Service
public class ServiceAdministrador {

    @Autowired
    private RepositoryAdministrador repositoryAdministrador;
    @Autowired
    private RepositoryRecrutador repositoryRecrutador;

    public EntityAdministrador adicionarAdministrador(EntityAdministrador administrador){
        return repositoryAdministrador.save(administrador);
    }

    public List<EntityAdministrador> listarAdministradores(){
        return repositoryAdministrador.findAll();
    }

    public List<EntityRecrutador> lsitarRecrutadores(String adminId){
        return repositoryRecrutador.findByAdministradorId(adminId);
    }

    public EntityRecrutador criarRecrutador(String administradorId, EntityRecrutador recrutador) {
        Optional<EntityAdministrador> administradorOpt = repositoryAdministrador.findById(administradorId);

        if (administradorOpt.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Administrador não encontrado");
        }

        EntityAdministrador administrador = administradorOpt.get();
        recrutador.setAdministradorId(administradorId);
        EntityRecrutador recrutadorSalvo = repositoryRecrutador.save(recrutador);

        administrador.getListaRecrutadores().add(recrutadorSalvo);
        repositoryAdministrador.save(administrador);

        return recrutadorSalvo;
    }

    public void removerRecrutador(String administradorId, String recrutadorId) {
        Optional<EntityAdministrador> administradorOpt = repositoryAdministrador.findById(administradorId);

        if (administradorOpt.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Administrador não encontrado");
        }

        EntityAdministrador administrador = administradorOpt.get();
        boolean removed = administrador.getListaRecrutadores().removeIf(r -> r.getId().equals(recrutadorId));

        if (!removed) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Recrutador não encontrado ou não vinculado a este administrador");
        }

        repositoryRecrutador.deleteById(recrutadorId);
        repositoryAdministrador.save(administrador);
    }

}

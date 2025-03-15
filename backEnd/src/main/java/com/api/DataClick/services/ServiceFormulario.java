package com.api.DataClick.services;

import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryFormulario;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class ServiceFormulario {

    @Autowired
    RepositoryFormulario repositoryFormulario;
    @Autowired
    RepositoryAdministrador repositoryAdministrador;
    @Autowired
    ServiceRecrutador serviceRecrutador;

    public EntityFormulario criarFormulario(EntityFormulario formulario, String adminId){
        EntityAdministrador admin = repositoryAdministrador.findById(adminId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Administrador não encontrado"));

        formulario.setAdminId(adminId);
        repositoryFormulario.save(formulario);
        admin.getFormularios().add(formulario);
        repositoryAdministrador.save(admin);
        return formulario;
    }

    public List<EntityFormulario> listarFormularios(){
        return repositoryFormulario.findAll();
    }

    public void removerFormulario(String formId){
        EntityFormulario form = repositoryFormulario.findById(formId).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Formulario não encontrado"));
        String adminId = form.getAdminId();
        EntityAdministrador admin = repositoryAdministrador.findById(adminId).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Adminitrador não encontrado"));
        admin.getFormularios().remove(form);
        repositoryFormulario.delete(form);
        repositoryAdministrador.save(admin);
    }

    public EntityFormulario bucarFormPorId(String id){
        return repositoryFormulario.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Formulario não encontrado"));

    }

    public List<EntityFormulario> buscarFormPorAdminId(String adminId){
        EntityAdministrador admin = repositoryAdministrador.findById(adminId).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Formulario não encontrado"));;
        return admin.getFormularios();
    }
}

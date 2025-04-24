package com.api.DataClick.services;

import com.api.DataClick.DTO.FormularioUpdateDTO;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryFormulario;
import com.api.DataClick.repositories.RepositoryRecrutador;
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
    RepositoryRecrutador repositoryRecrutador;

    public EntityFormulario criarFormulario(EntityFormulario formulario, String adminId){
        EntityAdministrador admin = repositoryAdministrador.findById(adminId)
                .orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.ADM_NAO_ENCONTRADO));

        formulario.setAdminId(adminId);
        repositoryFormulario.save(formulario);
        admin.getFormularios().add(formulario);
        repositoryAdministrador.save(admin);
        List<EntityRecrutador> listaRecrutadores = admin.getRecrutadores();
        for(EntityRecrutador recrutador : listaRecrutadores){
            recrutador.getFormularios().add(formulario);
            repositoryRecrutador.save(recrutador);
        }

        return formulario;
    }

    public void removerFormulario(String formId){
        EntityFormulario form = repositoryFormulario.findById(formId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.FORM_NAO_ENCONTRADO));
        String adminId = form.getAdminId();
        EntityAdministrador admin = repositoryAdministrador.findById(adminId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.ADM_NAO_ENCONTRADO));
        admin.getFormularios().remove(form);
        repositoryFormulario.delete(form);
        repositoryAdministrador.save(admin);
    }

    public EntityFormulario bucarFormPorId(String id){
        return repositoryFormulario.findById(id).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.FORM_NAO_ENCONTRADO));

    }

    public List<EntityFormulario> buscarFormPorAdminId(String adminId){
        EntityAdministrador admin = repositoryAdministrador.findById(adminId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.ADM_NAO_ENCONTRADO));
        return admin.getFormularios();
    }

    public EntityFormulario alterarFormulario(FormularioUpdateDTO dto, String id){
        EntityFormulario form = repositoryFormulario.findById(id).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.FORM_NAO_ENCONTRADO));
        form.setTituloForm(dto.getTitulo());
        return repositoryFormulario.save(form);
    }
}

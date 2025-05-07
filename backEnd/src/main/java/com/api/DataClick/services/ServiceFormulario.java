package com.api.DataClick.services;

import com.api.DataClick.DTO.FormularioUpdateDTO;
import com.api.DataClick.entities.*;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Service
public class ServiceFormulario {

    @Autowired
    RepositoryFormulario repositoryFormulario;
    @Autowired
    RepositoryAdministrador repositoryAdministrador;
    @Autowired
    RepositoryRecrutador repositoryRecrutador;
    @Autowired
    RepositoryCampo repositoryCampo;
    @Autowired
    RepositoryEvento repositoryEvento;

    public EntityFormulario criarFormulario(EntityFormulario formulario, String eventoId){
        EntityEvento evento = repositoryEvento.findById(eventoId)
                .orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.EVENTO_NAO_ENCONTRADO));
        EntityAdministrador admin = repositoryAdministrador.findById(evento.getEventoAdminId()).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.ADM_NAO_ENCONTRADO));
        formulario.setFormAdminId(evento.getEventoAdminId());
        repositoryFormulario.save(formulario);
        evento.getEventoFormularios().add(formulario);
        repositoryAdministrador.save(admin);
        repositoryEvento.save(evento);
        List<EntityRecrutador> listaRecrutadores = admin.getAdminRecrutadores();
        for(EntityRecrutador recrutador : listaRecrutadores){
            recrutador.getRecrutadorEventos().add(evento);
            repositoryRecrutador.save(recrutador);
        }
        return formulario;
    }

    public void removerFormulario(String formId){
        EntityFormulario form = repositoryFormulario.findById(formId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.FORM_NAO_ENCONTRADO));
        String adminId = form.getFormAdminId();
        List<EntityCampo> campos = form.getCampos();
        for(EntityCampo campo : campos){
            repositoryCampo.delete(campo);
        }
        EntityAdministrador admin = repositoryAdministrador.findById(adminId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.ADM_NAO_ENCONTRADO));
        List<EntityEvento> eventos = admin.getAdminEventos();
        for(EntityEvento evento : eventos){
         List<EntityFormulario> formularios = evento.getEventoFormularios();
            for (EntityFormulario f: formularios){
                f.getFormId().equals(formId);
                form = f;
                repositoryFormulario.delete(form);
            }
            repositoryEvento.save(evento);
        }
        repositoryFormulario.delete(form);
        repositoryAdministrador.save(admin);

    }

    public EntityFormulario bucarFormPorId(String id){
        return repositoryFormulario.findById(id).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.FORM_NAO_ENCONTRADO));

    }

    public List<EntityFormulario> ListarFormPorEventoId(String eventoId){
        EntityEvento eventos = repositoryEvento.findById(eventoId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.EVENTO_NAO_ENCONTRADO));
        return eventos.getEventoFormularios();
    }

    public EntityFormulario alterarFormulario(FormularioUpdateDTO dto, String id){
        EntityFormulario form = repositoryFormulario.findById(id).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.FORM_NAO_ENCONTRADO));
        form.setFomularioTitulo(dto.getTitulo());
        return repositoryFormulario.save(form);
    }
}

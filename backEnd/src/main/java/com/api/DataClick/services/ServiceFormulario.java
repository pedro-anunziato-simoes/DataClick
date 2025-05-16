package com.api.DataClick.services;

import com.api.DataClick.DTO.FormularioDTO;
import com.api.DataClick.entities.*;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

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

    public EntityFormulario criarFormulario(FormularioDTO dto, String eventoId){
        EntityEvento evento = repositoryEvento.findById(eventoId)
                .orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.EVENTO_NAO_ENCONTRADO));
        EntityAdministrador admin = repositoryAdministrador.findById(evento.getEventoAdminId()).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.ADM_NAO_ENCONTRADO));
        System.out.println(dto.getFormularioTituloDto());
        EntityFormulario formulario = new EntityFormulario(dto.getFormularioTituloDto(),admin.getUsuarioId(),eventoId,new ArrayList<>());
        formulario.setFormAdminId(evento.getEventoAdminId());
        repositoryFormulario.save(formulario);
        evento.getEventoFormularios().add(formulario);
        repositoryAdministrador.save(admin);
        repositoryEvento.save(evento);
        List<EntityRecrutador> listaRecrutadores = admin.getAdminRecrutadores();
        if(!listaRecrutadores.isEmpty()){
            for(EntityRecrutador recrutador : listaRecrutadores){
            recrutador.getRecrutadorEventos().add(evento);
            repositoryRecrutador.save(recrutador);
            }
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

    public EntityFormulario alterarFormulario(FormularioDTO dto, String id){
        EntityFormulario form = repositoryFormulario.findById(id).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.FORM_NAO_ENCONTRADO));
        form.setFomularioTitulo(dto.getFormularioTituloDto());
        return repositoryFormulario.save(form);
    }
}

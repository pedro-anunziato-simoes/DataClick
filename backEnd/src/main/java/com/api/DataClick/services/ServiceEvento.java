package com.api.DataClick.services;

import com.api.DataClick.DTO.EventoDTO;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityEvento;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryEvento;
import com.api.DataClick.repositories.RepositoryFormulario;
import com.api.DataClick.repositories.RepositoryRecrutador;
import lombok.Generated;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@Generated
public class ServiceEvento {

    @Autowired
    RepositoryEvento repositoryEvento;
    @Autowired
    RepositoryRecrutador repositoryRecrutador;
    @Autowired
    RepositoryAdministrador repositoryAdministrador;
    @Autowired
    RepositoryFormulario repositoryFormulario;

    public EntityEvento crirarEvento(EventoDTO dtoEvento, String adminId){
        EntityEvento evento = new EntityEvento(adminId,dtoEvento.getEventoTituloDto(), dtoEvento.getEventoDescricaoDto(), dtoEvento.getEventoDataDto(),new ArrayList<>());
        repositoryEvento.save(evento);
        EntityAdministrador adm = repositoryAdministrador.findById(adminId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.EVENTO_NAO_ENCONTRADO));
        adm.getAdminEventos().add(evento);
        for(EntityRecrutador recrutador: adm.getAdminRecrutadores()){
            recrutador.getRecrutadorEventos().add(evento);
            repositoryRecrutador.save(recrutador);
        }
        return evento;
    }

    public List<EntityEvento> listarEventosPorAdmin(String adminId){
       return repositoryEvento.findAllByEventoAdminId(adminId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.EVENTO_NAO_ENCONTRADO));
    }

    public List<EntityEvento> listarEventosProRec(String recrutadorId){
       EntityRecrutador recrutador = repositoryRecrutador.findById(recrutadorId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.REC_NAO_ENCONTRADO));
        return recrutador.getRecrutadorEventos();
    }

    public EntityEvento buscarEventoById(String eventoId){
        return repositoryEvento.findById(eventoId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.EVENTO_NAO_ENCONTRADO));
    }

    public EntityEvento alterarEvento(String eventoId, EventoDTO dto){
        EntityEvento evento = repositoryEvento.findById(eventoId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.EVENTO_NAO_ENCONTRADO));
        evento.setEventoTitulo(dto.getEventoTituloDto());
        evento.setEventoDescricao(dto.getEventoDescricaoDto());
        evento.setEventoData(dto.getEventoDataDto());
        return repositoryEvento.save(evento);
    }

    public void removerEvento(String eventoId){
        EntityEvento evento = repositoryEvento.findById(eventoId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.EVENTO_NAO_ENCONTRADO));
        for(EntityFormulario formulario: evento.getEventoFormularios()){
            repositoryFormulario.delete(formulario);
        }
        String adminId = evento.getEventoAdminId();
        EntityAdministrador admin = repositoryAdministrador.findById(adminId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.ADM_NAO_ENCONTRADO));
        admin.getAdminEventos().remove(evento);
        repositoryAdministrador.save(admin);
        repositoryEvento.delete(evento);
    }
}

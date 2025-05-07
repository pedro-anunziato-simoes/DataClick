package com.api.DataClick.services;

import com.api.DataClick.DTO.EventoUpdateDTO;
import com.api.DataClick.entities.EntityEvento;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryEvento;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ServiceEvento {

    @Autowired
    RepositoryEvento repositoryEvento;
    @Autowired
    RepositoryRecrutador repositoryRecrutador;

    public List<EntityEvento> listarEventosPorAdmin(String adminId){
       return repositoryEvento.findAllByadminId(adminId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.EVENTO_NAO_ENCONTRADO));
    }

    public List<EntityEvento> listarEventosProRec(String recrutadorId){
       EntityRecrutador recrutador = repositoryRecrutador.findById(recrutadorId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.REC_NAO_ENCONTRADO));
        return recrutador.getRecrutadorEventos();
    }

    public EntityEvento buscarEventoById(String eventoId){
        return repositoryEvento.findById(eventoId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.EVENTO_NAO_ENCONTRADO));
    }

    public EntityEvento alterarEvento(String eventoId, EventoUpdateDTO dto){
        EntityEvento evento = repositoryEvento.findById(eventoId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.EVENTO_NAO_ENCONTRADO));
        evento.setEventoTitulo(dto.getTituloEventoDTO());
        evento.setEventoDescricao(dto.getDescricaoEventoDTO());
        evento.setEventoData(dto.getDataEventoDTO());
        return repositoryEvento.save(evento);
    }
}

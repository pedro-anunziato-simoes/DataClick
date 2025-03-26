package com.api.DataClick.services;

import com.api.DataClick.entities.EntityFormualriosPreenchidos;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryFormualriosPreenchidos;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ServiceFormulariosPreenchidos {

    @Autowired
    private RepositoryFormualriosPreenchidos repositoryFormualriosPreenchidos;
    @Autowired
    private RepositoryRecrutador repositoryRecrutador;

    public List<EntityFormualriosPreenchidos> listarTodosFormulariosPreenchidos(){
        return repositoryFormualriosPreenchidos.findAll();
    }

    public EntityFormualriosPreenchidos adicionarFormulariosPreenchidos(EntityFormualriosPreenchidos formularios, String recrutadorId){
        EntityRecrutador recrutador = repositoryRecrutador.findById(recrutadorId).orElseThrow(()->new ExeptionNaoEncontrado(ExeceptionsMensage.REC_NAO_ENCONTRADO));
        String adminid = recrutador.getAdminId();
        formularios.setRecrutadorId(recrutadorId);
        formularios.setAdminId(adminid);
        return repositoryFormualriosPreenchidos.save(formularios);
    }

    public List<EntityFormualriosPreenchidos> buscarListaDeFormualriosPorIdRecrutador(String idRecrutador){
        String recrutadorId = repositoryRecrutador.findById(idRecrutador).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.REC_NAO_ENCONTRADO)).getUsuarioId();
        return repositoryFormualriosPreenchidos.findByrecrutadorId(recrutadorId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.LIST_FORM_NAO_ENCONTRADO));
    }
}

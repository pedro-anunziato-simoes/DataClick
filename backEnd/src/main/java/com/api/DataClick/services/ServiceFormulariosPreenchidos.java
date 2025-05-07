package com.api.DataClick.services;

import com.api.DataClick.entities.EntityFormulariosPreenchidos;
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

    public EntityFormulariosPreenchidos adicionarFormulariosPreenchidos(EntityFormulariosPreenchidos formularios, String recrutadorId){
        EntityRecrutador recrutador = repositoryRecrutador.findById(recrutadorId).orElseThrow(()->new ExeptionNaoEncontrado(ExeceptionsMensage.REC_NAO_ENCONTRADO));
        String adminid = recrutador.getRecrutadorAdminId();
        formularios.setRecrutadorId(recrutadorId);
        formularios.setFormularioPreenchidoAdminId(adminid);
        return repositoryFormualriosPreenchidos.save(formularios);
    }

    public List<EntityFormulariosPreenchidos> buscarListaDeFormualriosPorIdRecrutador(String idRecrutador){
        String recrutadorId = repositoryRecrutador.findById(idRecrutador).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.REC_NAO_ENCONTRADO)).getUsuarioId();
        return repositoryFormualriosPreenchidos.findByrecrutadorId(recrutadorId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.LIST_FORM_NAO_ENCONTRADO));
    }
}

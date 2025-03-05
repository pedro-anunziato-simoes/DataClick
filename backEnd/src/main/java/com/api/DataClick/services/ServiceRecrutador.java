package com.api.DataClick.services;

import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryFormulario;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ServiceRecrutador {

    @Autowired
    private RepositoryFormulario repositoryFormulario;

    public List<EntityFormulario> listarFormulario(){
        return repositoryFormulario.findAll();
    }

    /*
    public ?? preencherFormualrio(String formularioId){

    }*/
}

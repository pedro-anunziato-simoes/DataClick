package com.api.DataClick.services;

import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ServiceAdministrador {

    @Autowired
    private RepositoryAdministrador repositoryAdministrador;

    public void removerAdm(String admId){
        repositoryAdministrador.deleteById(admId);
    }
}

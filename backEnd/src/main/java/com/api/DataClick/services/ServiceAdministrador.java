package com.api.DataClick.services;

import com.api.DataClick.entities.Administrador;
import com.api.DataClick.entities.Recrutador;
import com.api.DataClick.repository.AdministradorRepository;
import com.api.DataClick.repository.RecrutadorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ServiceAdministrador {

    @Autowired
    private AdministradorRepository administradorRepository;
    @Autowired
    private RecrutadorRepository recrutadorRepository;

    public List<Administrador> listarAdministradores(){
        return administradorRepository.findAll();
    }
    public Administrador adicionarAdministrador(Administrador administrador){
        administradorRepository.save(administrador);
        return administrador;
    }

    public void deletarAdministrador(Long id){
        administradorRepository.deleteById(id);
    }

    public List<Recrutador> listarRecrutadores(){
        return recrutadorRepository.findAll();
    }

    /*public void removerRecrutador(String id){
        recrutadorRepository.deleteBy(id);
    }*/

    //criar relação 1-n com o Administrador
    public Recrutador adicionarRecrutador(Recrutador recrutador) {
        return recrutadorRepository.save(recrutador);
    }




}
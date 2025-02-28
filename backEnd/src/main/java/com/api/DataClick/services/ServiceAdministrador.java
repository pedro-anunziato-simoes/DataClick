package com.api.DataClick.services;

import com.api.DataClick.entities.Administrador;
import com.api.DataClick.entities.Formulario;
import com.api.DataClick.entities.Recrutador;
import com.api.DataClick.repository.AdministradorRepository;
import com.api.DataClick.repository.RecrutadorRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ServiceAdministrador {

    private AdministradorRepository administradorRepository;
    private RecrutadorRepository recrutadorRepository;

    public Administrador adicionarAdministrador(Administrador administrador){
        return administradorRepository.save(administrador);
    }

    public void deletarAdministrador(Long id){
        administradorRepository.deleteById(id);
    }

    public List<Recrutador> listarRecrutadores(){
        return recrutadorRepository.findAll();
    }

    public void removerRecrutador(Long id){
        recrutadorRepository.deleteById(id);
    }


    //criar relação 1-n com o Administrador
    public Recrutador adicionarRecrutador(Recrutador recrutador) {
        return recrutadorRepository.save(recrutador);
    }




}
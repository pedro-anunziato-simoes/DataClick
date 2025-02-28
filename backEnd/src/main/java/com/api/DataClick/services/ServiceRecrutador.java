package com.api.DataClick.services;

import com.api.DataClick.entities.Formulario;
import com.api.DataClick.repository.FormularioRepository;
import com.api.DataClick.repository.RecrutadorRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ServiceRecrutador {

    private RecrutadorRepository recrutadorRepository;
    private FormularioRepository formularioRepository;

    public List<Formulario> listarFormularios() {
        return formularioRepository.findAll();
    }



}
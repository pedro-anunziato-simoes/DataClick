package com.api.DataClick.services;

import com.api.DataClick.entities.Formulario;
import com.api.DataClick.repository.FormularioRepository;
import com.api.DataClick.repository.RecrutadorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ServiceRecrutador {

    @Autowired
    private RecrutadorRepository recrutadorRepository;
    @Autowired
    private FormularioRepository formularioRepository;

    public List<Formulario> listarFormularios() {
        return formularioRepository.findAll();
    }

}
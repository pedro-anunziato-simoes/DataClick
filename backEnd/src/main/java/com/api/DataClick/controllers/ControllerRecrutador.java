package com.api.DataClick.controllers;

import com.api.DataClick.entities.Formulario;
import com.api.DataClick.services.ServiceRecrutador;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/recrutadores")
public class ControllerRecrutador {

    @Autowired
    private ServiceRecrutador serviceRecrutador;

    @GetMapping
    public List<Formulario> listarFormularios(){
        return serviceRecrutador.listarFormularios();
    }


}

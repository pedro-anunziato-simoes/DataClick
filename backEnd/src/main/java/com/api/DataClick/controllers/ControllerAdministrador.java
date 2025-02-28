package com.api.DataClick.controllers;

import com.api.DataClick.entities.Administrador;
import com.api.DataClick.entities.Recrutador;
import com.api.DataClick.services.ServiceAdministrador;
import com.api.DataClick.services.ServiceRecrutador;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/administradores")
@Tag(name = "Administradores", description = "Funcionalidades dos administradores")
public class ControllerAdministrador {

    @Autowired
    private ServiceAdministrador serviceAdministrador;
    @Autowired
    private ServiceRecrutador serviceRecrutador;

    @GetMapping
    public List<Administrador> listarAdministradores(){
        return serviceAdministrador.listarAdministradores();
    }

    @PostMapping("/adicionar")
    public Administrador criarAdministrador(Administrador administrador){
        return serviceAdministrador.adicionarAdministrador(administrador);
    }

    @Operation(summary = "Listar todos os recrutadores",description = "Retora todos os recrutadores")
    @GetMapping("/listarRecrutadores")
    public List<Recrutador> listarRecrutadores(){
        return serviceAdministrador.listarRecrutadores();
    }

    /*
    @PostMapping
    public void removerRecrutador(String id){
        serviceAdministrador.removerRecrutador(id);
    }
    */

}

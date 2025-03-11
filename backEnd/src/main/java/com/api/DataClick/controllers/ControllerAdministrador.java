package com.api.DataClick.controllers;

import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.services.ServiceAdministrador;
import com.api.DataClick.services.ServiceRecrutador;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/administradores")
@Tag(name = "Administrador", description = "Endpoints de funcionalidades de administradores")
public class ControllerAdministrador {

    @Autowired
    private ServiceAdministrador serviceAdministrador;
    @Autowired
    private ServiceRecrutador serviceRecrutador;

    @GetMapping
    @Operation(summary = "Listar todos os adminitradores", description = "Retorna uma lista de adminitradores")
    public List<EntityAdministrador> listarAdministradores(){
        return serviceAdministrador.listarAdministradores();
    }

    @PostMapping
    @Operation(summary = "Adicionar um novo Adminitrador", description = "Retorna o adminitrador que foi criado")
    public EntityAdministrador adicionarAdministrador(EntityAdministrador administrador){
        return serviceAdministrador.adicionarAdmin(administrador);
    }

    @DeleteMapping("/{id}/remover")
    @Operation(summary = "Remove um Adminitrador", description = "Não retorna nada")
    public void removerAdm(@PathVariable String id){
        serviceAdministrador.removerAdm(id);
    }
}

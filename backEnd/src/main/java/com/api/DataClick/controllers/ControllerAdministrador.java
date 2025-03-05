package com.api.DataClick.controllers;

import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.services.ServiceAdministrador;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/administradores")
public class ControllerAdministrador {

    @Autowired
    private ServiceAdministrador serviceAdministrador;

    /*
    @GetMapping
    public List<EntityAdministrador> listarAdministradores(){
        return serviceAdministrador.listarAdminitradores();
    }*/

    // Criar um recrutador vinculado a um administrador
    @PostMapping("/{administradorId}/recrutadores")
    public ResponseEntity<EntityRecrutador> criarRecrutador(
            @PathVariable String administradorId,
            @RequestBody EntityRecrutador recrutador) {
        EntityRecrutador novoRecrutador = serviceAdministrador.criarRecrutador(administradorId, recrutador);
        return ResponseEntity.status(HttpStatus.CREATED).body(novoRecrutador);
    }

    // Remover um recrutador vinculado a um administrador
    @DeleteMapping("/{administradorId}/recrutadores/{recrutadorId}")
    public ResponseEntity<Void> removerRecrutador(
            @PathVariable String administradorId,
            @PathVariable String recrutadorId) {
        serviceAdministrador.removerRecrutador(administradorId, recrutadorId);
        return ResponseEntity.noContent().build();
    }
}

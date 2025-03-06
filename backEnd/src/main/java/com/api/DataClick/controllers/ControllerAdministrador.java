package com.api.DataClick.controllers;

import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.services.ServiceAdministrador;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/administradores")
@Tag(name = "Administrador", description = "Endpoints de funcionalidades de administradores")
public class ControllerAdministrador {

    @Autowired
    private ServiceAdministrador serviceAdministrador;

    @GetMapping
    @Operation(summary = "Listar todos os adminitradores", description = "Retorna uma lista de adminitradores")
    public List<EntityAdministrador> listarAdministradores(){
        return serviceAdministrador.listarAdministradores();
    }

    @PostMapping
    @Operation(summary = "Adicionar um novo Adminitrador", description = "Retorna o adminitrador que foi criado")
    public EntityAdministrador adicionarAdministrador(EntityAdministrador administrador){
        return serviceAdministrador.adicionarAdministrador(administrador);
    }

    @PostMapping("/{administradorId}/recrutadores")
    @Operation(summary = "Criar recrutador", description = "Cria um recrutador apartir de um objeto(Entity Recrutador) passado pelo Body e um id d tipo string passado por parametro na URL")
    public ResponseEntity<EntityRecrutador> criarRecrutador(
            @PathVariable String administradorId,
            @RequestBody EntityRecrutador recrutador) {
        EntityRecrutador novoRecrutador = serviceAdministrador.criarRecrutador(administradorId, recrutador);
        return ResponseEntity.status(HttpStatus.CREATED).body(novoRecrutador);
    }

    @DeleteMapping("/{administradorId}/recrutadores/{recrutadorId}")
    @Operation(summary = "Remover recrutador", description = "remove um recrutador pelo id do adminitrador e pelo id do recrutador que deseja ser excluido")
    public ResponseEntity<Void> removerRecrutador(
            @PathVariable String administradorId,
            @PathVariable String recrutadorId) {
        serviceAdministrador.removerRecrutador(administradorId, recrutadorId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{adminitradorId}/listRecrutadores")
    @Operation(summary = "Listar todos os recrutadores", description = "Retorna uma lista de recrutadores")
    public List<EntityRecrutador> listarRecrutadores(@PathVariable String adminitradorId){
        return serviceAdministrador.lsitarRecrutadores(adminitradorId);
    }
}

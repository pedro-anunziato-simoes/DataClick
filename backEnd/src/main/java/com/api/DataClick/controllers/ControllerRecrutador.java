package com.api.DataClick.controllers;

import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.services.ServiceAdministrador;
import com.api.DataClick.services.ServiceRecrutador;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/recrutadores")
@Tag(name = "Recrutadores", description = "Endpoints de funcionalidades de recrutadores")
public class ControllerRecrutador {

    @Autowired
    private ServiceRecrutador serviceRecrutador;
    @Autowired
    private ServiceAdministrador serviceAdministrador;


    @PostMapping("/{administradorId}/add")
    @Operation(summary = "Criar recrutador", description = "Cria um recrutador apartir de um objeto(Entity Recrutador) passado pelo Body e um id d tipo string passado por parametro na URL")
    public ResponseEntity<EntityRecrutador> criarRecrutador(
            @PathVariable String administradorId,
            @RequestBody EntityRecrutador recrutador) {
        EntityRecrutador novoRecrutador = serviceRecrutador.criarRecrutador(administradorId, recrutador);
        return ResponseEntity.status(HttpStatus.CREATED).body(novoRecrutador);
    }

    @DeleteMapping("/{administradorId}/remover/{recrutadorId}")
    @Operation(summary = "Remover recrutador", description = "remove um recrutador pelo id do adminitrador e pelo id do recrutador que deseja ser excluido")
    public ResponseEntity<Void> removerRecrutador(
            @PathVariable String administradorId,
            @PathVariable String recrutadorId) {
        serviceRecrutador.removerRecrutador(administradorId, recrutadorId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{adminitradorId}/list")
    @Operation(summary = "Listar todos os recrutadores", description = "Retorna uma lista de recrutadores")
    public List<EntityRecrutador> listarRecrutadores(@PathVariable String adminitradorId){
        return serviceRecrutador.listarRecrutadores(adminitradorId);
    }
}

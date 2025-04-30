package com.api.DataClick.controllers;


import com.api.DataClick.DTO.CampoUpdateDTO;
import com.api.DataClick.entities.EntityCampo;
import com.api.DataClick.enums.TipoCampo;
import com.api.DataClick.repositories.RepositoryCampo;
import com.api.DataClick.services.ServiceCampo;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/campos")
@Tag(name = "Campos", description = "Endpoints de funcionalidades de campos")
public class ControllerCampo {

    @Autowired
    private ServiceCampo serviceCampo;

    //Adm/Recrutador
    @GetMapping("/findByFormId/{formId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Lista todos os campos pelo id do formulario", description = "Retorna todos os campos de um determinado formulario")
    public ResponseEntity<List<EntityCampo>> listarCamposPorFormularioId(@PathVariable String formId, @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ROLE_RECRUTADOR"))) {
            System.out.println("Acesso negado: usuário não tem permissão");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        List<EntityCampo> campos = serviceCampo.listarCamposByFormularioId(formId);
        if (campos.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        return ResponseEntity.ok(campos);
    }


    //Adm
    @PostMapping("/add/{formId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Adiciona um campo a um formulario", description = "Retorna o campo adicionado ao formulario")
    public ResponseEntity<EntityCampo> adicionarCampoForm(@RequestBody EntityCampo campo, @PathVariable String formId, @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            System.out.println("Acesso negado: usuário não é ADMIN");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        EntityCampo campoAdicionado = serviceCampo.adicionarCampo(campo, formId);
        return ResponseEntity.status(HttpStatus.CREATED).body(campoAdicionado);
    }

    //Adm
    @DeleteMapping("/remover/{campoId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Remover campo", description = "remove um campo de um formulario pelo id do campo")
    public ResponseEntity<Void> removerCampo(@PathVariable String campoId, @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            System.out.println("Acesso negado: usuário não é ADMIN");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        serviceCampo.removerCampo(campoId);
        return ResponseEntity.noContent().build();
    }

    //Adm/Recrutador
    @GetMapping("/{campoId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Buscar Campo por Id", description = "Busca um campo pelo Id")
    public ResponseEntity<EntityCampo> buscarCampoById(@PathVariable String campoId, @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ROLE_RECRUTADOR"))) {
            System.out.println("Acesso negado: usuário não tem permissão");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        EntityCampo campo = serviceCampo.buscarCampoById(campoId);
        if (campo == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        return ResponseEntity.ok(campo);
    }

    //Adm
    @PostMapping("/alterar/{campoId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Altera um campo", description = "Altera um campo pelo id do mesmo")
    public ResponseEntity<EntityCampo> alterarCampo(@PathVariable String campoId, @RequestBody CampoUpdateDTO dto, @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            System.out.println("Acesso negado: usuário não é ADMIN");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        EntityCampo campoAlterado = serviceCampo.alterarCampo(campoId, dto.getTipo(), dto.getTitulo());
        return ResponseEntity.ok(campoAlterado);
    }

}
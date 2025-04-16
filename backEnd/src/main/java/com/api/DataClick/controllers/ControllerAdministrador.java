package com.api.DataClick.controllers;

import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.services.ServiceAdministrador;
import com.api.DataClick.services.ServiceRecrutador;
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
import java.util.Optional;

@RestController
@RequestMapping("/administradores")
@Tag(name = "Administradores", description = "Endpoints de funcionalidades de administradores")
public class ControllerAdministrador {

    @Autowired
    private ServiceAdministrador serviceAdministrador;
    @Autowired
    private ServiceRecrutador serviceRecrutador;

    //Adm
    @DeleteMapping("/{id}/remover")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Remove um Administrador", description = "Não retorna nada")
    public ResponseEntity<Void> removerAdm(@PathVariable String id,   @AuthenticationPrincipal UserDetails userDetails){

        System.out.println("Authorities do usuário: " + userDetails.getAuthorities());
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            System.out.println("Acesso negado: usuário não é ADMIN");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        serviceAdministrador.removerAdm(id);
        return ResponseEntity.noContent().build();
    }
}

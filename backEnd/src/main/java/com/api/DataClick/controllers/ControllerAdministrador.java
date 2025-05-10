package com.api.DataClick.controllers;

import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.Usuario;
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

    //Adm
    @DeleteMapping("/{id}/remover")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Remove um Administrador", description = "Não retorna nada")
    public ResponseEntity<Void> removerAdm(@PathVariable String id,   @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        serviceAdministrador.removerAdm(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/info")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Busca as informações do adminitrador", description = "Retorna a informações do adminitrador")
    public ResponseEntity<EntityAdministrador> infoAdm(@AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        Usuario usuarioLogado  = (Usuario) userDetails;
        String adminId = usuarioLogado.getUsuarioId();
        EntityAdministrador adm = serviceAdministrador.infoAdm(adminId);
        return ResponseEntity.ok(adm);
    }

    @PostMapping("/alterar/email")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Altera o e-amil do administrador", description = "altera o e-mail do adm")
    public ResponseEntity<Void> alterarEmail(@AuthenticationPrincipal UserDetails userDetails,@RequestBody String email){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        Usuario usuarioLogado  = (Usuario) userDetails;
        String adminId = usuarioLogado.getUsuarioId();
        serviceAdministrador.alterarEmail(email,adminId);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/alterar/senha")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Altera a senha do administrador", description = "altera a senha do adm")
    public ResponseEntity<Void> alterarSenha(@AuthenticationPrincipal UserDetails userDetails,@RequestBody String senha){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        Usuario usuarioLogado  = (Usuario) userDetails;
        String adminId = usuarioLogado.getUsuarioId();
        serviceAdministrador.alterarSenha(senha,adminId);
        return ResponseEntity.noContent().build();
    }
}

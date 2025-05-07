package com.api.DataClick.controllers;

import com.api.DataClick.DTO.EventoUpdateDTO;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityEvento;
import com.api.DataClick.entities.Usuario;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.services.ServiceEvento;
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
@RequestMapping("/eventos")
@Tag(name = "Eventos", description = "Endpoints de funcionalidades de eventos")
public class ControllerEvento {

    @Autowired
    ServiceEvento serviceEvento;

    @GetMapping
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Buscar eventos por admin", description = "Retorna a lista de eventos")
    public ResponseEntity<List<EntityEvento>> listarTodosEventosPorAdm(@AuthenticationPrincipal UserDetails userDetails){
        Usuario usuario = (Usuario) userDetails;
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.ok(serviceEvento.listarEventosProRec(usuario.getUsuarioId()));
        }
        return ResponseEntity.ok(serviceEvento.listarEventosPorAdmin(usuario.getUsuarioId()));
    }

    @GetMapping("/{eventoId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Buscar eventos por id", description = "Retorna a lista de eventos")
    public ResponseEntity<EntityEvento> buscarEvento(@PathVariable String eventoId,@AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.ok(serviceEvento.buscarEventoById(eventoId));
        }
        return ResponseEntity.ok(serviceEvento.buscarEventoById(eventoId));
    }

    @PostMapping("/alterar/{eventoId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Alterar um formulario", description = "Retorna o evento alterado")
    public ResponseEntity<EntityEvento> alterarEvento(@RequestBody EventoUpdateDTO dto,@PathVariable String eventoId,@AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        return ResponseEntity.ok(serviceEvento.alterarEvento(eventoId,dto));
    }

}

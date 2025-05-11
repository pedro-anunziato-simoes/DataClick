package com.api.DataClick.controllers;

import com.api.DataClick.DTO.EventoDTO;
import com.api.DataClick.entities.EntityEvento;
import com.api.DataClick.entities.Usuario;
import com.api.DataClick.services.ServiceEvento;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.Generated;
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
    @Generated
    public ResponseEntity<EntityEvento> buscarEvento(@PathVariable String eventoId,@AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_USER") || a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        return ResponseEntity.ok(serviceEvento.buscarEventoById(eventoId));
    }

    @PostMapping("/alterar/{eventoId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Alterar um formulario", description = "Retorna o evento alterado")
    public ResponseEntity<EntityEvento> alterarEvento(@RequestBody EventoDTO dto,@PathVariable String eventoId,@AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        return ResponseEntity.ok(serviceEvento.alterarEvento(eventoId,dto));
    }

    @PostMapping("/criar")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Alterar um formulario", description = "Retorna o evento alterado")
    public ResponseEntity<EntityEvento> criarEvento(@RequestBody EventoDTO evento, @AuthenticationPrincipal UserDetails userDetails){
        Usuario usuario = (Usuario) userDetails;
        String ususarioId = usuario.getUsuarioId();
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        return ResponseEntity.status(HttpStatus.CREATED).body(serviceEvento.crirarEvento(evento,ususarioId));
    }

    @DeleteMapping("/remove/{eventoId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Alterar um formulario", description = "Retorna o evento alterado")
    public ResponseEntity<Void> removerEvento(@PathVariable String eventoId,@AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        serviceEvento.removerEvento(eventoId);
        return ResponseEntity.noContent().build();
    }
}

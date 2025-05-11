package com.api.DataClick.controllers;

import com.api.DataClick.DTO.FormularioDTO;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.Usuario;
import com.api.DataClick.repositories.RepositoryRecrutador;
import com.api.DataClick.services.ServiceEvento;
import com.api.DataClick.services.ServiceFormulario;
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
@RequestMapping("/formularios")
@Tag(name = "Formularios", description = "Endpoints de funcionalidades de formularios")
public class ControllerFormulario {

    @Autowired
    ServiceFormulario serviceFormulario;
    @Autowired
    ServiceEvento serviceEvento;
    @Autowired
    RepositoryRecrutador repositoryRecrutador;

    @PostMapping("/alterar/{formId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "altera formulario", description = "")
    public ResponseEntity<EntityFormulario> alterarFormulario(@RequestBody FormularioDTO dto, @PathVariable String formId, @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        serviceFormulario.alterarFormulario(dto,formId);
        return ResponseEntity.ok(serviceFormulario.bucarFormPorId(formId));
    }
    //Adm
    @PostMapping("/add/{eventoId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Criar formulario", description = "Retorna o formulario salvo/criado no banco de dados")
    public ResponseEntity<EntityFormulario> criarFormulario(@RequestBody FormularioDTO form, @PathVariable String eventoId, @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        EntityFormulario formularioSalvo = serviceFormulario.criarFormulario(form, eventoId);
        return ResponseEntity.status(HttpStatus.CREATED).body(formularioSalvo);
    }
    //Adm
    @DeleteMapping("/remove/{id}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Deleta/remover formulario", description = "Deleta o formulario do banco de dados e retira ele da lista de fomrulario dos admintradores/recrutadores")
    public  ResponseEntity<EntityFormulario> removerFormulario(@PathVariable String id,   @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        serviceFormulario.removerFormulario(id);
        return ResponseEntity.noContent().build();
    }
    //Adm/Recrutador
    @GetMapping("/{id}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Busca um formulario pelo id-formulario", description = "Retorna um formulario cujo id foi inserido")
    public ResponseEntity<EntityFormulario> buscarForm(@PathVariable String id, @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_USER") || a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        EntityFormulario formulario = serviceFormulario.bucarFormPorId(id);
        if (formulario == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        return ResponseEntity.ok(formulario);
    }
    //Adm/Recrutador
    @GetMapping("/formulario/evento/{eventoId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Busca a lista de formularios pelo id-administrador", description = "Retorna uma lista de formularios vinculada ao adminitrador")
    public ResponseEntity<List<EntityFormulario>> buscarFormByEventoId(@PathVariable String eventoId, @AuthenticationPrincipal UserDetails userDetails){
        Usuario usuario = (Usuario) userDetails;
        String usuarioId = usuario.getUsuarioId();
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
                return ResponseEntity.ok(serviceFormulario.ListarFormPorEventoId(eventoId));
        }
            return ResponseEntity.ok(serviceFormulario.ListarFormPorEventoId(eventoId));
    }

}

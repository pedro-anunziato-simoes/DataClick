package com.api.DataClick.controllers;

import com.api.DataClick.DTO.FormularioPreenchidosDTO;
import com.api.DataClick.entities.EntityFormulariosPreenchidos;
import com.api.DataClick.entities.Usuario;
import com.api.DataClick.services.ServiceFormulariosPreenchidos;
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
@RequestMapping("/formualriosPreenchidos")
@Tag(name = "FormualriosPreenchidos", description = "Endpoints de funcionalidades dos FormualriosPreenchidos")
public class ControllerFormulariosPreenchidos {

    @Autowired
    ServiceFormulariosPreenchidos serviceFormulariosPreenchidos;

    //Adm
    @GetMapping("/{eventoId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Buscar formularios por evento", description = "Retorna a lista de formularios que foram preenchidasno evento enviado o Id")
    public ResponseEntity<List<EntityFormulariosPreenchidos>> buscarFormByEventoId(@PathVariable String eventoId, @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        List<EntityFormulariosPreenchidos> formularios = serviceFormulariosPreenchidos.buscarFormualriosPreechidosPorEvento(eventoId);
        if (formularios.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        return ResponseEntity.ok(formularios);
    }

    //Recrutador
    @PostMapping("/add")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Adicionar lista de formularios preenchidos", description = "Adiciona uma lista de fomularios ao banco de dados com a identificação do recrutador que preencheu os formularios e o adminitrador no qual o recrutador faz parte")
    public ResponseEntity<EntityFormulariosPreenchidos> adicionarFormulariosPreenchidos(@RequestBody FormularioPreenchidosDTO forms, @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ROLE_USER"))) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        Usuario usuarioLogado = (Usuario) userDetails;
        EntityFormulariosPreenchidos formulariosAdicionados = serviceFormulariosPreenchidos.adicionarFomulariosPreenchidos(forms);
        return ResponseEntity.status(HttpStatus.CREATED).body(formulariosAdicionados);
    }

}

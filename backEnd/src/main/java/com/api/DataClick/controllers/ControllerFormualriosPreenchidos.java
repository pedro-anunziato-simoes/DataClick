package com.api.DataClick.controllers;

import com.api.DataClick.entities.EntityFormualriosPreenchidos;
import com.api.DataClick.entities.EntityFormulario;
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
public class ControllerFormualriosPreenchidos {

    @Autowired
    ServiceFormulariosPreenchidos serviceFormulariosPreenchidos;

    //Adm
    @GetMapping("/{recrutadorId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Buscar formulario por recrutador", description = "Retorna a lista de formularios que foram preenchidas pelo recrutador buscado")
    public ResponseEntity<List<EntityFormualriosPreenchidos>> buscarFormByRecrutadorId(@PathVariable String recrutadorId, @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            System.out.println("Acesso negado: usuário não é ADMIN");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        List<EntityFormualriosPreenchidos> formularios = serviceFormulariosPreenchidos.buscarListaDeFormualriosPorIdRecrutador(recrutadorId);
        if (formularios.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        return ResponseEntity.ok(formularios);
    }
    //Adm/Recrutador
    @PostMapping("/add")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Adicionar lista de formularios preenchidos", description = "Adiciona uma lista de fomularios ao banco de dados com a identificação do recrutador que preencheu os formularios e o adminitrador no qual o recrutador faz parte")
    public ResponseEntity<EntityFormualriosPreenchidos> adicionarFormualriosPreenchidos( @RequestBody EntityFormualriosPreenchidos forms,
                                                                                         @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ROLE_USER"))) {
            System.out.println("Acesso negado: usuário não tem permissão");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        Usuario usuarioLogado = (Usuario) userDetails;

        EntityFormualriosPreenchidos formulariosAdicionados = serviceFormulariosPreenchidos.adicionarFormulariosPreenchidos(forms, usuarioLogado.getUsuarioId());
        return ResponseEntity.status(HttpStatus.CREATED).body(formulariosAdicionados);
    }

}

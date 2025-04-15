package com.api.DataClick.controllers;

import com.api.DataClick.DTO.RegisterRecrutadorDTO;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.entities.Usuario;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.services.ServiceAdministrador;
import com.api.DataClick.services.ServiceRecrutador;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/recrutadores")
@Tag(name = "Recrutadores", description = "Endpoints de funcionalidades de recrutadores")
@SecurityRequirement(name = "bearerAuth")
public class ControllerRecrutador {

    @Autowired
    private ServiceRecrutador serviceRecrutador;
    @Autowired
    private ServiceAdministrador serviceAdministrador;
    @Autowired
    private PasswordEncoder passwordEncoder;

   @GetMapping
   @Operation(summary = "Listar todos os recrutadores",description = "Retorna todos os recrutadores")
   public List<EntityRecrutador> listarRecrutadores(){
       return serviceRecrutador.listarTodosRecrutadores();
   }


    @DeleteMapping("/remover/{recrutadorId}")
    @Operation(summary = "Remover recrutador", description = "remove um recrutador pelo id do adminitrador e pelo id do recrutador que deseja ser excluido")
    public ResponseEntity<Void> removerRecrutador(
            @PathVariable String recrutadorId) {
        serviceRecrutador.removerRecrutador(recrutadorId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{adminitradorId}/list")
    @Operation(summary = "Listar todos os recrutadores", description = "Retorna uma lista de recrutadores")
    public List<EntityRecrutador> listarRecrutadores(@PathVariable String adminitradorId){
        return serviceRecrutador.listarRecrutadores(adminitradorId);
    }

    @GetMapping("/{recrutadorId}")
    @Operation(summary = "Buscar recrutador", description = "Buscar recrutador com base no id")
    public EntityRecrutador buscarRecrut(@PathVariable String recrutadorId){
        return serviceRecrutador.buscarRecrut(recrutadorId);
    }

    @PostMapping
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Criar recrutador", description = "Apenas Admins podem criar recrutadores")
    public ResponseEntity<EntityRecrutador> criarRecrutador(
            @RequestBody @Valid RegisterRecrutadorDTO recrutadorDTO,
            @AuthenticationPrincipal UserDetails userDetails) {

        System.out.println("Authorities do usuário: " + userDetails.getAuthorities());

        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            System.out.println("Acesso negado: usuário não é ADMIN");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        Usuario admin = (Usuario) userDetails;

        String encryptedPassword = passwordEncoder.encode(recrutadorDTO.senha());

        EntityRecrutador recrutador = new EntityRecrutador(
                recrutadorDTO.nome(),
                encryptedPassword,
                recrutadorDTO.telefone(),
                recrutadorDTO.email(),
                admin.getUsuarioId(),
                new ArrayList<>(),
                UserRole.USER
        );

        EntityRecrutador novoRecrutador = serviceRecrutador.criarRecrutador(recrutador);
        return ResponseEntity.status(HttpStatus.CREATED).body(novoRecrutador);
    }


}

package com.api.DataClick.controllers;

import com.api.DataClick.DTO.RecrutadorUpdateDTO;
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

    //Adm
    @DeleteMapping("/remover/{recrutadorId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Remover recrutador", description = "remove um recrutador pelo id do adminitrador e pelo id do recrutador que deseja ser excluido")
    public ResponseEntity<Void> removerRecrutador(@PathVariable String id,   @AuthenticationPrincipal UserDetails userDetails) {

        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            System.out.println("Acesso negado: usuário não é ADMIN");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        serviceRecrutador.removerRecrutador(id);
        return ResponseEntity.noContent().build();
    }
    //Adm
    @GetMapping("/list")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Listar todos os recrutadores", description = "Retorna uma lista de recrutadores")
    public ResponseEntity<List<EntityRecrutador>> listarRecrutadores(@AuthenticationPrincipal UserDetails userDetails){

        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            System.out.println("Acesso negado: usuário não é ADMIN");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        Usuario usuarioLogado  = (Usuario) userDetails;
        List<EntityRecrutador> recrutadores = serviceRecrutador.listarRecrutadores(usuarioLogado.getUsuarioId());
        if (recrutadores.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        return ResponseEntity.ok(recrutadores);
    }

    //Adm
    @GetMapping("/{recrutadorId}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Buscar recrutador", description = "Buscar recrutador com base no id")
    public ResponseEntity<EntityRecrutador> buscarRecrut(@PathVariable String recrutadorId, @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            System.out.println("Acesso negado: usuário não é ADMIN");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        EntityRecrutador recrutador = serviceRecrutador.buscarRecrut(recrutadorId);
        if (recrutador == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        return ResponseEntity.ok(recrutador);
    }
    //Adm
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

    @PostMapping("/alterar/{recrutadorId}")
    @Operation(summary = "Alterar um recrutador", description = "Altera um recrutador por meio do id")
    ResponseEntity<EntityRecrutador> alterarRecrutador(@PathVariable String recrutadorId,@RequestBody RecrutadorUpdateDTO dto, @AuthenticationPrincipal UserDetails userDetails){
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            System.out.println("Acesso negado: usuário não é ADMIN");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        EntityRecrutador recrutadorAtualizado = serviceRecrutador.alterarRecrutador(recrutadorId, dto);
        return ResponseEntity.ok(recrutadorAtualizado);
    }
}

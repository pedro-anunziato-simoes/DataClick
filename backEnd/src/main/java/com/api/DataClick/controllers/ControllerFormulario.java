package com.api.DataClick.controllers;

import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.Usuario;
import com.api.DataClick.services.ServiceFormulario;
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

@RestController
@RequestMapping("/formularios")
@Tag(name = "Formularios", description = "Endpoints de funcionalidades de formularios")
public class ControllerFormulario {

    @Autowired
    ServiceFormulario serviceFormulario;

    @Autowired
    ServiceRecrutador serviceRecrutador;

    //Adm
    @PostMapping("/add")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Criar formulario", description = "Retorna o formulario salvo/criado no banco de dados")
    public ResponseEntity<EntityFormulario> criarFormulario(@RequestBody EntityFormulario form, @AuthenticationPrincipal UserDetails userDetails){

        System.out.println("Authorities do usuário: " + userDetails.getAuthorities());
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            System.out.println("Acesso negado: usuário não é ADMIN");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        Usuario admin = (Usuario) userDetails;
        String adminId = admin.getUsuarioId();

        form.setAdminId(adminId);

        EntityFormulario formularioSalvo = serviceFormulario.criarFormulario(form, adminId);
        return ResponseEntity.status(HttpStatus.CREATED).body(formularioSalvo);
    }
    //Adm
    @DeleteMapping("/formualrio/remove/{id}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Deleta/remover formulario", description = "Deleta o formulario do banco de dados e retira ele da lista de fomrulario dos admintradores/recrutadores")
    public  ResponseEntity<EntityFormulario> removerFormulario(@PathVariable String id,   @AuthenticationPrincipal UserDetails userDetails){
        System.out.println("Authorities do usuário: " + userDetails.getAuthorities());
        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            System.out.println("Acesso negado: usuário não é ADMIN");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        serviceFormulario.removerFormulario(id);
        return ResponseEntity.noContent().build();
    }
    //Adm/Recrutador
    @GetMapping("/{id}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Busca um formulario pelo id-formulario", description = "Retorna um formaulario cujo id foi inserido")
    public ResponseEntity<EntityFormulario> buscarForm(@PathVariable String id, @AuthenticationPrincipal UserDetails userDetails){
        System.out.println("Authorities do usuário: " + userDetails.getAuthorities());

        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_USER") || a.getAuthority().equals("ROLE_ADMIN"))) {
            System.out.println("Acesso negado: usuário não tem permissão");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        EntityFormulario formulario = serviceFormulario.bucarFormPorId(id);
        if (formulario == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        return ResponseEntity.ok(formulario);
    }
    //Adm/Recrutador
    @GetMapping("/todos-formularios")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Busca a lista de formularios pelo id-administrador", description = "Retorna uma lista de formularios vinculada ao adminitrador")
    public ResponseEntity<List<EntityFormulario>> buscarFormByAdminId( @AuthenticationPrincipal UserDetails userDetails){
        System.out.println("Authorities do usuário: " + userDetails.getAuthorities());

        if (userDetails.getAuthorities().stream()
                .noneMatch(a -> a.getAuthority().equals("ROLE_USER") || a.getAuthority().equals("ROLE_ADMIN"))) {
            System.out.println("Acesso negado: usuário não tem permissão");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        boolean isAdmin = userDetails.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        Usuario usuarioLogado  = (Usuario) userDetails;
        String adminId;
        if (isAdmin) {
            adminId = usuarioLogado.getUsuarioId();
        } else {
            adminId = serviceRecrutador.buscarAdminIdPorRecrutadorId(usuarioLogado.getUsuarioId())
                    .orElseThrow(() -> new RuntimeException("Recrutador não vinculado a um admin"));
        }
        List<EntityFormulario> formularios = serviceFormulario.buscarFormPorAdminId(adminId);


        return formularios.isEmpty() ?
                ResponseEntity.status(HttpStatus.NOT_FOUND).build() :
                ResponseEntity.ok(formularios);
    }

}

package com.api.DataClick.controllers;


import com.api.DataClick.DTO.AuthenticationDTO;
import com.api.DataClick.DTO.RegisterAdminDTO;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryRecrutador;
import com.api.DataClick.services.ServiceToken;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Map;

@RestController
@RequestMapping("auth")
public class ControllerAuthentication {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private RepositoryRecrutador repositoryRecrutador;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private RepositoryAdministrador repositoryAdministrador;
    @Autowired
    private ServiceToken serviceToken;

    @PostMapping("/login")
    public ResponseEntity login(@RequestBody @Valid AuthenticationDTO data){
        try {
            var usernamePassword = new UsernamePasswordAuthenticationToken(data.email(), data.senha());
            var auth = authenticationManager.authenticate(usernamePassword);

            var token = serviceToken.generateToken((UserDetails) auth.getPrincipal());

            return ResponseEntity.ok().body(Map.of("token", token));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Credenciais inválidas");
        }
    }

    @PostMapping("/register")
    public ResponseEntity<?> registerAdmin(@RequestBody @Valid RegisterAdminDTO data) {
        if (repositoryAdministrador.findByEmail(data.email()) != null ||
                repositoryRecrutador.findByEmail(data.email()) != null) {
            return ResponseEntity.badRequest().body("Email já registrado!");
        }

        String encryptedPassword = passwordEncoder.encode(data.senha());

        EntityAdministrador admin = new EntityAdministrador(
                data.cnpj(),
                data.nome(),
                encryptedPassword,
                data.telefone(),
                data.email(),
                UserRole.ADMIN
        );

        repositoryAdministrador.save(admin);
        return ResponseEntity.ok().build();
    }
}

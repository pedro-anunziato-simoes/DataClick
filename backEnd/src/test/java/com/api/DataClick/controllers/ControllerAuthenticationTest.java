package com.api.DataClick.controllers;


import com.api.DataClick.DTO.AuthenticationDTO;
import com.api.DataClick.DTO.RegisterAdminDTO;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryRecrutador;
import com.api.DataClick.services.ServiceToken;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.core.Authentication;

import java.util.Collections;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ControllerAuthenticationTest {
    @Mock
    private AuthenticationManager authenticationManager;

    @Mock
    private RepositoryRecrutador repositoryRecrutador;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private RepositoryAdministrador repositoryAdministrador;

    @Mock
    private ServiceToken serviceToken;

    @InjectMocks
    private ControllerAuthentication controller;

    private AuthenticationDTO authDto;
    private RegisterAdminDTO registerDto;
    private EntityAdministrador admin;
    private EntityRecrutador recrutador;

    @BeforeEach
    void setUp() {
        authDto = new AuthenticationDTO("admin@test.com", "senha123");
        registerDto = new RegisterAdminDTO(
                "123456789",
                "Admin Teste",
                "senha123",
                "11999998888",
                "admin@test.com"
        );

        admin = new EntityAdministrador(
                "123456789",
                "Admin Teste",
                "senha123",
                "11999998888",
                "admin@test.com",
                UserRole.ADMIN
        );

        recrutador = new EntityRecrutador(
                "Recrutador Teste",
                "senha123",
                "11999997777",
                "recrutador@test.com",
                "admin-001",
                UserRole.USER,
                Collections.emptyList()
        );
    }

    @Test
    void login_ComCredenciaisValidas_DeveRetornarToken() {
        Authentication auth = mock(Authentication.class);
        when(authenticationManager.authenticate(any())).thenReturn(auth);
        when(serviceToken.generateToken(any())).thenReturn("token-jwt");

        ResponseEntity<?> response = controller.login(authDto);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertTrue(response.getBody() instanceof Map);
        assertEquals("token-jwt", ((Map<?, ?>) response.getBody()).get("token"));
    }

    @Test
    void login_ComCredenciaisInvalidas_DeveRetornarNaoAutorizado() {

        when(authenticationManager.authenticate(any()))
                .thenThrow(new BadCredentialsException("Erro"));

        ResponseEntity<?> response = controller.login(authDto);

        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
        assertEquals("Credenciais inválidas", response.getBody());
    }

    @Test
    void registerAdmin_ComEmailNovo_DeveCriarAdministrador() {

        when(repositoryAdministrador.findByEmail(anyString())).thenReturn(null);
        when(repositoryRecrutador.findByEmail(anyString())).thenReturn(null);
        when(passwordEncoder.encode(anyString())).thenReturn("senha-criptografada");

        ResponseEntity<?> response = controller.registerAdmin(registerDto);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        verify(repositoryAdministrador).save(any(EntityAdministrador.class));
    }

    @Test
    void registerAdmin_ComEmailExistenteEmAdministradores_DeveRetornarErro() {
        when(repositoryAdministrador.findByEmail(anyString())).thenReturn(admin);

        ResponseEntity<?> response = controller.registerAdmin(registerDto);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertEquals("Email já registrado!", response.getBody());
        verify(repositoryAdministrador, never()).save(any());
    }

    @Test
    void registerAdmin_ComEmailExistenteEmRecrutadores_DeveRetornarErro() {
        when(repositoryAdministrador.findByEmail(anyString())).thenReturn(null);
        when(repositoryRecrutador.findByEmail(anyString())).thenReturn(recrutador);

        ResponseEntity<?> response = controller.registerAdmin(registerDto);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertEquals("Email já registrado!", response.getBody());
        verify(repositoryAdministrador, never()).save(any());
    }
}

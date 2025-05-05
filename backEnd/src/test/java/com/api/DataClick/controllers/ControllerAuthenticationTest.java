package com.api.DataClick.controllers;
import com.api.DataClick.DTO.AuthenticationDTO;
import com.api.DataClick.DTO.RegisterAdminDTO;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryRecrutador;
import com.api.DataClick.services.ServiceToken;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;


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
    private ControllerAuthentication controllerAuthentication;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void login_Sucesso_DeveRetornarToken() {
        AuthenticationDTO data = new AuthenticationDTO("test@example.com", "senha123");
        UserDetails userDetails = User.withUsername("test@example.com")
                .password("senha123")
                .authorities("ROLE_ADMIN")
                .build();

        Authentication auth = mock(Authentication.class);
        when(auth.getPrincipal()).thenReturn(userDetails);
        when(authenticationManager.authenticate(any())).thenReturn(auth);
        when(serviceToken.generateToken(userDetails)).thenReturn("token_jwt_mockado");

        ResponseEntity<?> response = controllerAuthentication.login(data);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertTrue(response.getBody().toString().contains("token=token_jwt_mockado"));
    }

    @Test
    void login_CredenciaisInvalidas_DeveRetornarNaoAutorizado() {
        AuthenticationDTO data = new AuthenticationDTO("invalido@email.com", "senhaerrada");
        when(authenticationManager.authenticate(any()))
                .thenThrow(new BadCredentialsException("Credenciais inválidas"));

        ResponseEntity<?> response = controllerAuthentication.login(data);

        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
        assertEquals("Credenciais inválidas", response.getBody());
    }

    @Test
    void registerAdmin_NovoRegistro_DeveCriarAdministrador() {
        RegisterAdminDTO data = new RegisterAdminDTO(
                "12345678901234",
                "Novo Admin",
                "senha123",
                "11999998888",
                "novo@email.com"
        );

        when(repositoryAdministrador.findByEmail(any())).thenReturn(null);
        when(repositoryRecrutador.findByEmail(any())).thenReturn(null);
        when(passwordEncoder.encode("senha123")).thenReturn("senha_criptografada");

        ResponseEntity<?> response = controllerAuthentication.registerAdmin(data);

        verify(repositoryAdministrador).save(any(EntityAdministrador.class));
        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void registerAdmin_EmailExistenteNoAdministrador_DeveRetornarErro() {
        RegisterAdminDTO data = new RegisterAdminDTO(
                "Admin Teste",
                "existente@email.com",
                "senha123",
                "11999999999",
                "12345678901234"
        );

        EntityAdministrador adminExistente = new EntityAdministrador(
                "12345678901234",
                "Admin Teste",
                "senha123",
                "11999999999",
                "existente@email.com",
                UserRole.ADMIN
        );

        when(repositoryAdministrador.findByEmail("existente@email.com")).thenReturn(adminExistente);

        ResponseEntity<?> response = controllerAuthentication.registerAdmin(data);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertEquals("Email já registrado!", response.getBody());

        verify(repositoryAdministrador).findByEmail("existente@email.com");
    }

    @Test
    void registerAdmin_EmailNaoExisteNoAdministrador_DeveVerificarRecrutador() {
        RegisterAdminDTO data = new RegisterAdminDTO(
                "Admin Teste",
                "novo@email.com",
                "senha123",
                "11999999999",
                "12345678901234"
        );

        when(repositoryAdministrador.findByEmail("novo@email.com")).thenReturn(null);
        when(repositoryRecrutador.findByEmail("novo@email.com")).thenReturn(null);

        ResponseEntity<?> response = controllerAuthentication.registerAdmin(data);


        verify(repositoryAdministrador).findByEmail("novo@email.com");
        verify(repositoryRecrutador).findByEmail("novo@email.com");
    }
}

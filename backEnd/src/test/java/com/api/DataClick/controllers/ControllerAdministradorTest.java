package com.api.DataClick.controllers;


import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.Usuario;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.services.ServiceAdministrador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;


public class ControllerAdministradorTest {
    @Mock
    private ServiceAdministrador serviceAdministrador;

    @InjectMocks
    private ControllerAdministrador controllerAdministrador;

    private Usuario adminUser;
    private Usuario regularUser;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        adminUser = new EntityAdministrador(
                "12345678000100",
                "Admin Test",
                "senha",
                "44999999999",
                "admin@test.com",
                UserRole.ADMIN
        );
        adminUser.setUsuarioId("admin123");

        regularUser = new EntityAdministrador(
                "12345678000101",
                "Usuário Regular",
                "senha",
                "44888888888",
                "regular@test.com",
                UserRole.USER
        );
        regularUser.setUsuarioId("user456");
    }

    @Test
    void removerAdm_deveRetornarForbiddenParaNaoAdmin() {
        ResponseEntity<Void> response = controllerAdministrador.removerAdm("anyId", regularUser);
        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceAdministrador, never()).removerAdm(anyString());
    }

    @Test
    void removerAdm_deveRemoverQuandoAdmin() {
        ResponseEntity<Void> response = controllerAdministrador.removerAdm("admin123", adminUser);
        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
        verify(serviceAdministrador).removerAdm("admin123");
    }

    @Test
    void infoAdm_deveRetornarForbiddenParaNaoAdmin() {
        ResponseEntity<EntityAdministrador> response = controllerAdministrador.infoAdm(regularUser);
        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceAdministrador, never()).infoAdm(anyString());
    }

    @Test
    void infoAdm_deveRetornarNoContentQuandoAdmin() {
        EntityAdministrador adminMock = new EntityAdministrador(
                "12345678000100",
                "Admin Mock",
                "senha",
                "44999999999",
                "mock@test.com",
                UserRole.ADMIN
        );
        when(serviceAdministrador.infoAdm("admin123")).thenReturn(adminMock);

        ResponseEntity<EntityAdministrador> response = controllerAdministrador.infoAdm(adminUser);
        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
        verify(serviceAdministrador).infoAdm("admin123");
    }

    @Test
    void alterarEmail_deveRetornarForbiddenParaNaoAdmin() {
        controllerAdministrador.alterarEmail(regularUser, "novo@email.com");
        verify(serviceAdministrador, never()).alterarEmail(anyString(), anyString());
    }

    @Test
    void alterarEmail_deveAlterarQuandoAdmin() {
        controllerAdministrador.alterarEmail(adminUser, "novo@email.com");
        verify(serviceAdministrador).alterarEmail("novo@email.com", "admin123");
    }

    @Test
    void alterarSenha_deveRetornarForbiddenParaNaoAdmin() {
        controllerAdministrador.alterarSenha(regularUser, "novaSenha");
        verify(serviceAdministrador, never()).alterarSenha(anyString(), anyString());
    }

    @Test
    void alterarSenha_deveAlterarQuandoAdmin() {
        controllerAdministrador.alterarSenha(adminUser, "novaSenha");
        verify(serviceAdministrador).alterarSenha("novaSenha", "admin123");
    }
}

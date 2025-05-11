package com.api.DataClick.controllers;


import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.entities.Usuario;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.services.ServiceAdministrador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.authentication;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
public class ControllerAdministradorTest {

    @Mock
    private ServiceAdministrador serviceAdministrador;

    @InjectMocks
    private ControllerAdministrador controller;

    private EntityAdministrador admin;
    private EntityRecrutador usuarioComum;

    @BeforeEach
    void setUp() {
        admin = new EntityAdministrador(
                "123456789",
                "Admin Full",
                "senha123",
                "11999998888",
                "admin@dataclick.com",
                UserRole.ADMIN
        );
        admin.setUsuarioId("adm-001");

        usuarioComum = new EntityRecrutador(
                "User Normal",
                "senha456",
                "11999997777",
                "user@dataclick.com",
                "adm-001",
                UserRole.USER,
                Collections.emptyList()
        );
        usuarioComum.setUsuarioId("user-001");
    }

    @Test
    void removerAdm_ComPermissaoAdmin_DeveChamarServico() {
        ResponseEntity<Void> response = controller.removerAdm("adm-002", admin);

        verify(serviceAdministrador).removerAdm("adm-002");
        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
    }

    @Test
    void removerAdm_SemPermissaoAdmin_DeveRetornarForbidden() {
        ResponseEntity<Void> response = controller.removerAdm("adm-001", usuarioComum);

        verifyNoInteractions(serviceAdministrador);
        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
    }

    @Test
    void infoAdm_ComUsuarioAdmin_DeveRetornarInformacoes() {
        EntityAdministrador admMock = new EntityAdministrador(
                "987654321",
                "Mock Admin",
                "senha",
                "11888889999",
                "mock@adm.com",
                UserRole.ADMIN
        );
        when(serviceAdministrador.infoAdm("adm-001")).thenReturn(admMock);

        ResponseEntity<EntityAdministrador> response = controller.infoAdm(admin);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(admMock, response.getBody());
        verify(serviceAdministrador).infoAdm("adm-001");
    }

    @Test
    void alterarEmail_ComPermissao_DeveAtualizarEmail() {
        String novoEmail = "novo@email.com";

        ResponseEntity<Void> response = controller.alterarEmail(admin, novoEmail);

        verify(serviceAdministrador).alterarEmail(novoEmail, "adm-001");
        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
    }

    @Test
    void alterarSenha_ComPermissao_DeveAtualizarSenha() {
        String novaSenha = "NovaSenha123@";

        ResponseEntity<Void> response = controller.alterarSenha(admin, novaSenha);

        verify(serviceAdministrador).alterarSenha(novaSenha, "adm-001");
        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
    }

    @Test
    void infoAdm_SemPermissaoAdmin_DeveRetornarForbidden() {
        ResponseEntity<EntityAdministrador> response = controller.infoAdm(usuarioComum);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verifyNoInteractions(serviceAdministrador);
    }

    @Test
    void alterarEmail_SemPermissao_DeveRetornarForbidden() {
        ResponseEntity<Void> response = controller.alterarEmail(usuarioComum, "email@teste.com");

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verifyNoInteractions(serviceAdministrador);
    }

    @Test
    void alterarSenha_SemPermissao_DeveRetornarForbidden() {
        ResponseEntity<Void> response = controller.alterarSenha(usuarioComum, "senha");

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verifyNoInteractions(serviceAdministrador);
    }


}

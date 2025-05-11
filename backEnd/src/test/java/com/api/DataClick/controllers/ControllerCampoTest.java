package com.api.DataClick.controllers;


import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
import com.api.DataClick.DTO.CampoDTO;
import com.api.DataClick.entities.EntityCampo;
import com.api.DataClick.enums.TipoCampo;
import com.api.DataClick.services.ServiceCampo;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;


@ExtendWith(MockitoExtension.class)
public class ControllerCampoTest {

    @Mock
    private ServiceCampo serviceCampo;

    @InjectMocks
    private ControllerCampo controller;

    private UserDetails adminUser;
    private UserDetails comumUser;
    private UserDetails unauthorizedUser;
    private EntityCampo campo;
    private CampoDTO campoDTO;

    @BeforeEach
    void setUp() {
        adminUser = User.withUsername("admin@test.com")
                .password("senha")
                .authorities(new SimpleGrantedAuthority("ROLE_ADMIN"))
                .build();

        comumUser = User.withUsername("user@test.com")
                .password("senha")
                .authorities(new SimpleGrantedAuthority("ROLE_USER"))
                .build();

        unauthorizedUser = User.withUsername("invalid@test.com")
                .password("senha")
                .authorities(Collections.emptyList())
                .build();

        campo = new EntityCampo("Nome", TipoCampo.TEXTO);
        campo.setCampoId("campo-123");

        campoDTO = new CampoDTO();
    }

    @Test
    void listarCampos_ComPermissaoAdmin_DeveRetornarLista() {
        when(serviceCampo.listarCamposByFormularioId(anyString()))
                .thenReturn(List.of(campo));

        ResponseEntity<List<EntityCampo>> response =
                controller.listarCamposPorFormularioId("form-123", adminUser);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertFalse(response.getBody().isEmpty());
    }

    @Test
    void listarCampos_ComPermissaoUser_DeveRetornarLista() {
        when(serviceCampo.listarCamposByFormularioId(anyString()))
                .thenReturn(List.of(campo));

        ResponseEntity<List<EntityCampo>> response =
                controller.listarCamposPorFormularioId("form-123", comumUser);

        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void listarCampos_SemPermissao_DeveRetornarForbidden() {
        ResponseEntity<List<EntityCampo>> response =
                controller.listarCamposPorFormularioId("form-123", unauthorizedUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
    }

    @Test
    void adicionarCampo_ComPermissaoAdmin_DeveRetornarCriado() {
        when(serviceCampo.adicionarCampo(any(), anyString()))
                .thenReturn(campo);

        ResponseEntity<EntityCampo> response =
                controller.adicionarCampoForm(campoDTO, "form-123", adminUser);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertNotNull(response.getBody());
    }

    @Test
    void adicionarCampo_SemPermissao_DeveRetornarForbidden() {
        ResponseEntity<EntityCampo> response =
                controller.adicionarCampoForm(campoDTO, "form-123", comumUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
    }

    @Test
    void removerCampo_ComPermissaoAdmin_DeveRetornarSucesso() {
        ResponseEntity<Void> response =
                controller.removerCampo("campo-123", adminUser);

        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
        verify(serviceCampo).removerCampo("campo-123");
    }

    @Test
    void removerCampo_SemPermissao_DeveRetornarForbidden() {
        ResponseEntity<Void> response =
                controller.removerCampo("campo-123", comumUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
    }

    @Test
    void buscarCampo_ComPermissaoAdmin_DeveRetornarCampo() {
        when(serviceCampo.buscarCampoById(anyString()))
                .thenReturn(campo);

        ResponseEntity<EntityCampo> response =
                controller.buscarCampoById("campo-123", adminUser);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(campo, response.getBody());
    }
    @Test
    void alterarCampo_ComPermissaoAdmin_DeveRetornarAtualizado() {
        when(serviceCampo.alterarCampo(anyString(), any()))
                .thenReturn(campo);

        ResponseEntity<EntityCampo> response =
                controller.alterarCampo("campo-123", campoDTO, adminUser);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        verify(serviceCampo).alterarCampo("campo-123", campoDTO);
    }

    @Test
    void alterarCampo_SemPermissao_DeveRetornarForbidden() {
        ResponseEntity<EntityCampo> response =
                controller.alterarCampo("campo-123", campoDTO, comumUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
    }
}

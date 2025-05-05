package com.api.DataClick.controllers;

import com.api.DataClick.DTO.CampoUpdateDTO;
import com.api.DataClick.entities.EntityCampo;
import com.api.DataClick.entities.Usuario;
import com.api.DataClick.enums.TipoCampo;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.services.ServiceCampo;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ControllerCampoTest {

    @Mock
    private ServiceCampo serviceCampo;

    @InjectMocks
    private ControllerCampo controllerCampo;

    private UserDetails adminUser;
    private UserDetails recrutadorUser;
    private UserDetails invalidoUser;
    private EntityCampo campo;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        adminUser = new Usuario() {{
            setUsuarioId("admin123");
            setRole(UserRole.ADMIN);
        }};

        recrutadorUser = new Usuario() {{
            setUsuarioId("rec789");
            setRole(UserRole.USER);
        }};

        invalidoUser = new Usuario() {{
            setUsuarioId("user456");
            setRole(UserRole.INVALID);
        }};

        campo = new EntityCampo("Campo Teste", TipoCampo.TEXTO);
        campo.setCampoId("campo123");
    }

    @Test
    void listarCamposPorFormularioId_deveRetornarForbiddenParaUsuarioNaoAutorizado() {
        ResponseEntity<List<EntityCampo>> response =
                controllerCampo.listarCamposPorFormularioId("form123", invalidoUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceCampo, never()).listarCamposByFormularioId(anyString());
    }

    @Test
    void listarCamposPorFormularioId_deveRetornarCamposParaAdmin() {
        when(serviceCampo.listarCamposByFormularioId("form123"))
                .thenReturn(List.of(campo));

        ResponseEntity<List<EntityCampo>> response =
                controllerCampo.listarCamposPorFormularioId("form123", adminUser);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(1, response.getBody().size());
        verify(serviceCampo).listarCamposByFormularioId("form123");
    }

    @Test
    void listarCamposPorFormularioId_deveRetornarNotFoundParaListaVazia() {
        when(serviceCampo.listarCamposByFormularioId("form123"))
                .thenReturn(Collections.emptyList());

        ResponseEntity<List<EntityCampo>> response =
                controllerCampo.listarCamposPorFormularioId("form123", recrutadorUser);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    void adicionarCampoForm_deveRetornarForbiddenParaNaoAdmin() {
        ResponseEntity<EntityCampo> response =
                controllerCampo.adicionarCampoForm(campo, "form123", recrutadorUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceCampo, never()).adicionarCampo(any(), anyString());
    }

    @Test
    void adicionarCampoForm_deveCriarCampoParaAdmin() {
        when(serviceCampo.adicionarCampo(campo, "form123")).thenReturn(campo);

        ResponseEntity<EntityCampo> response =
                controllerCampo.adicionarCampoForm(campo, "form123", adminUser);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertEquals(campo, response.getBody());
        verify(serviceCampo).adicionarCampo(campo, "form123");
    }

    @Test
    void removerCampo_deveRetornarForbiddenParaNaoAdmin() {
        ResponseEntity<Void> response =
                controllerCampo.removerCampo("campo123", recrutadorUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceCampo, never()).removerCampo(anyString());
    }

    @Test
    void removerCampo_deveRemoverParaAdmin() {
        ResponseEntity<Void> response =
                controllerCampo.removerCampo("campo123", adminUser);

        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
        verify(serviceCampo).removerCampo("campo123");
    }

    @Test
    void buscarCampoById_deveRetornarForbiddenParaUsuarioNaoAutorizado() {
        ResponseEntity<EntityCampo> response =
                controllerCampo.buscarCampoById("campo123", invalidoUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceCampo, never()).buscarCampoById(anyString());
    }

    @Test
    void buscarCampoById_deveRetornarCampoParaAdmin() {
        when(serviceCampo.buscarCampoById("campo123")).thenReturn(campo);

        ResponseEntity<EntityCampo> response =
                controllerCampo.buscarCampoById("campo123", adminUser);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(campo, response.getBody());
    }

    @Test
    void buscarCampoById_deveRetornarNotFoundParaCampoInexistente() {
        when(serviceCampo.buscarCampoById("campo999")).thenReturn(null);

        ResponseEntity<EntityCampo> response =
                controllerCampo.buscarCampoById("campo999", recrutadorUser);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    void alterarCampo_deveRetornarForbiddenParaNaoAdmin() {
        CampoUpdateDTO dto = new CampoUpdateDTO();

        ResponseEntity<EntityCampo> response =
                controllerCampo.alterarCampo("campo123", dto, recrutadorUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceCampo, never()).alterarCampo(anyString(), anyString(), anyString());
    }

    @Test
    void alterarCampo_deveAtualizarParaAdmin() {
        CampoUpdateDTO dto = new CampoUpdateDTO();
        dto.setTipo("NUMERO");
        dto.setTitulo("Título Atualizado");

        EntityCampo campoAtualizado = new EntityCampo("Título Atualizado", TipoCampo.NUMERO);

        when(serviceCampo.alterarCampo(
                "campo123",
                dto.getTipo(),
                dto.getTitulo()
        )).thenReturn(campoAtualizado);

        ResponseEntity<EntityCampo> response =
                controllerCampo.alterarCampo("campo123", dto, adminUser);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(campoAtualizado, response.getBody());

        verify(serviceCampo).alterarCampo(
                "campo123",
                "NUMERO",
                "Título Atualizado"
        );
    }
}


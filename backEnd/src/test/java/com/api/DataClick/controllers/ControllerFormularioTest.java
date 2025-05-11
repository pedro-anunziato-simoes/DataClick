package com.api.DataClick.controllers;


import com.api.DataClick.DTO.FormularioDTO;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.services.ServiceFormulario;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;



@ExtendWith(MockitoExtension.class)
public class ControllerFormularioTest {

    @Mock
    private ServiceFormulario serviceFormulario;

    @InjectMocks
    private ControllerFormulario controller;

    private EntityAdministrador admin;
    private EntityRecrutador recrutador;
    private EntityRecrutador invalido;
    private EntityFormulario formulario;
    private FormularioDTO formularioDTO;

    @BeforeEach
    void setUp() {
        admin = new EntityAdministrador(
                "123456789",
                "Admin Teste",
                "senha123",
                "11999998888",
                "admin@test.com",
                UserRole.ADMIN
        );
        admin.setUsuarioId("adm-001");

        invalido = new EntityRecrutador(
                "Recrutador Teste",
                "senha123",
                "11999997777",
                "recrutador@test.com",
                "admin-001",
                UserRole.INVALID,
                Collections.emptyList()
        );
        invalido.setUsuarioId("rec-002");

        recrutador = new EntityRecrutador(
                "Recrutador Teste",
                "senha123",
                "11999997777",
                "recrutador@test.com",
                "admin-001",
                UserRole.USER,
                Collections.emptyList()
        );
        recrutador.setUsuarioId("rec-001");

        formulario = new EntityFormulario("admin-001", "novo-form");
        formulario.setFormId("form-123");
        formulario.setFormularioTitulo("Formulário Teste");

        formularioDTO = new FormularioDTO();
        formularioDTO.setFormularioTituloDto("Novo Formulário");
    }

    @Test
    void alterarFormulario_Admin_DeveRetornarOk() {
        when(serviceFormulario.bucarFormPorId("form-123")).thenReturn(formulario);

        ResponseEntity<EntityFormulario> response =
                controller.alterarFormulario(formularioDTO, "form-123", admin);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        verify(serviceFormulario).alterarFormulario(formularioDTO, "form-123");
        verify(serviceFormulario).bucarFormPorId("form-123");
    }

    @Test
    void alterarFormulario_UsuarioNaoAutorizado_DeveRetornarForbidden() {
        ResponseEntity<EntityFormulario> response =
                controller.alterarFormulario(formularioDTO, "form-123", recrutador);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verifyNoInteractions(serviceFormulario);
    }

    @Test
    void criarFormulario_Admin_DeveRetornarCriado() {
        when(serviceFormulario.criarFormulario(any(), anyString()))
                .thenReturn(formulario);

        ResponseEntity<EntityFormulario> response =
                controller.criarFormulario(formularioDTO, "evento-123", admin);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertEquals(formulario, response.getBody());
        verify(serviceFormulario).criarFormulario(formularioDTO, "evento-123");
    }

    @Test
    void criarFormulario_UsuarioNaoAutorizado_DeveRetornarForbidden() {
        ResponseEntity<EntityFormulario> response =
                controller.criarFormulario(formularioDTO, "evento-123", recrutador);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verifyNoInteractions(serviceFormulario);
    }

    @Test
    void removerFormulario_Admin_DeveRetornarNoContent() {
        ResponseEntity<EntityFormulario> response =
                controller.removerFormulario("form-123", admin);

        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
        verify(serviceFormulario).removerFormulario("form-123");
    }

    @Test
    void removerFormulario_UsuarioNaoAutorizado_DeveRetornarForbidden() {
        ResponseEntity<EntityFormulario> response =
                controller.removerFormulario("form-123", recrutador);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verifyNoInteractions(serviceFormulario);
    }

    @Test
    void buscarForm_UsuarioAutorizado_DeveRetornarFormulario() {
        when(serviceFormulario.bucarFormPorId("form-123")).thenReturn(formulario);

        ResponseEntity<EntityFormulario> responseAdmin =
                controller.buscarForm("form-123", admin);
        assertEquals(HttpStatus.OK, responseAdmin.getStatusCode());

        ResponseEntity<EntityFormulario> responseRecrutador =
                controller.buscarForm("form-123", recrutador);
        assertEquals(HttpStatus.OK, responseRecrutador.getStatusCode());

        verify(serviceFormulario, times(2)).bucarFormPorId("form-123");
    }

    @Test
    void buscarForm_FormularioNaoEncontrado_DeveRetornarNotFound() {
        when(serviceFormulario.bucarFormPorId("form-123")).thenReturn(null);

        ResponseEntity<EntityFormulario> response =
                controller.buscarForm("form-123", admin);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    void buscarForm_UsuarioNaoAutorizado_DeveRetornarForbidden() {
        ResponseEntity<EntityFormulario> response =
                controller.buscarForm("form-123", invalido);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
    }

    @Test
    void buscarFormByEventoId_DeveRetornarListaFormularios() {
        List<EntityFormulario> formularios = List.of(formulario);
        when(serviceFormulario.ListarFormPorEventoId("evento-123")).thenReturn(formularios);

        ResponseEntity<List<EntityFormulario>> responseAdmin =
                controller.buscarFormByEventoId("evento-123", admin);
        assertEquals(HttpStatus.OK, responseAdmin.getStatusCode());

        ResponseEntity<List<EntityFormulario>> responseRecrutador =
                controller.buscarFormByEventoId("evento-123", recrutador);
        assertEquals(HttpStatus.OK, responseRecrutador.getStatusCode());

        verify(serviceFormulario, times(2)).ListarFormPorEventoId("evento-123");
    }
}

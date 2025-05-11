package com.api.DataClick.controllers;

import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityFormulariosPreenchidos;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.entities.Usuario;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.services.ServiceFormulariosPreenchidos;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;


import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;



@ExtendWith(MockitoExtension.class)
public class ControllerFormulariosPreenchidosTest {


    @Mock
    private ServiceFormulariosPreenchidos serviceFormulariosPreenchidos;

    @InjectMocks
    private ControllerFormulariosPreenchidos controller;

    private EntityAdministrador admin;
    private EntityRecrutador recrutador;
    private EntityRecrutador invalido;
    private EntityFormulariosPreenchidos formularioPreenchido;

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
                "user@test.com",
                "adm-001",
                UserRole.INVALID,
                Collections.emptyList()
        );
        invalido.setUsuarioId("user-001");

        recrutador = new EntityRecrutador(
                "Recrutador Teste",
                "senha123",
                "11999997777",
                "recrutador@test.com",
                "adm-001",
                UserRole.USER,
                Collections.emptyList()
        );
        recrutador.setUsuarioId("rec-001");

        formularioPreenchido = new EntityFormulariosPreenchidos(Collections.emptyList());
        formularioPreenchido.setFormulariosPreId("form-001");
    }


    @Test
    void buscarFormByRecrutadorId_AdminComDados_DeveRetornarOk() {
        when(serviceFormulariosPreenchidos.buscarListaDeFormualriosPorIdRecrutador(anyString()))
                .thenReturn(List.of(formularioPreenchido));

        ResponseEntity<List<EntityFormulariosPreenchidos>> response =
                controller.buscarFormByRecrutadorId("rec-001", admin);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertFalse(response.getBody().isEmpty());
        verify(serviceFormulariosPreenchidos).buscarListaDeFormualriosPorIdRecrutador("rec-001");
    }

    @Test
    void buscarFormByRecrutadorId_AdminSemDados_DeveRetornarNotFound() {
        when(serviceFormulariosPreenchidos.buscarListaDeFormualriosPorIdRecrutador(anyString()))
                .thenReturn(Collections.emptyList());

        ResponseEntity<List<EntityFormulariosPreenchidos>> response =
                controller.buscarFormByRecrutadorId("rec-001", admin);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    void buscarFormByRecrutadorId_NaoAdmin_DeveRetornarForbidden() {
        ResponseEntity<List<EntityFormulariosPreenchidos>> response =
                controller.buscarFormByRecrutadorId("rec-001", recrutador);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verifyNoInteractions(serviceFormulariosPreenchidos);
    }

    @Test
    void adicionarFormulariosPreenchidos_Admin_DeveRetornarCriado() {
        when(serviceFormulariosPreenchidos.adicionarFormulariosPreenchidos(any(), anyString()))
                .thenReturn(formularioPreenchido);

        ResponseEntity<EntityFormulariosPreenchidos> response =
                controller.adicionarFormulariosPreenchidos(formularioPreenchido, admin);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertEquals(formularioPreenchido, response.getBody());
    }

    @Test
    void adicionarFormulariosPreenchidos_User_DeveRetornarCriado() {
        when(serviceFormulariosPreenchidos.adicionarFormulariosPreenchidos(any(), anyString()))
                .thenReturn(formularioPreenchido);

        ResponseEntity<EntityFormulariosPreenchidos> response =
                controller.adicionarFormulariosPreenchidos(formularioPreenchido, recrutador);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
    }

    @Test
    void adicionarFormulariosPreenchidos_NaoAutorizado_DeveRetornarForbidden() {
        ResponseEntity<EntityFormulariosPreenchidos> response =
                controller.adicionarFormulariosPreenchidos(formularioPreenchido, invalido);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verifyNoInteractions(serviceFormulariosPreenchidos);
    }

    @Test
    void adicionarFormulariosPreenchidos_DevePassarUsuarioIdCorreto() {
        ArgumentCaptor<String> usuarioIdCaptor = ArgumentCaptor.forClass(String.class);
        when(serviceFormulariosPreenchidos.adicionarFormulariosPreenchidos(any(), usuarioIdCaptor.capture()))
                .thenReturn(formularioPreenchido);

        controller.adicionarFormulariosPreenchidos(formularioPreenchido, admin);

        assertEquals("adm-001", usuarioIdCaptor.getValue());
    }
}

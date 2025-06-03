package com.api.DataClick.controllers;

import com.api.DataClick.DTO.EventoDTO;
import com.api.DataClick.DTO.FormularioPreenchidosDTO;
import com.api.DataClick.entities.*;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryFormualriosPreenchidos;
import com.api.DataClick.repositories.RepositoryRecrutador;
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
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;


import java.util.*;

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
    private FormularioPreenchidosDTO formsDTO;
    private EntityFormulariosPreenchidos formsPreenchidos;

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

        invalido = new EntityRecrutador(
                "Recrutador Invalido",
                "senha123",
                "11999996666",
                "invalido@test.com",
                "admin-001",
                UserRole.INVALID,
                Collections.emptyList()
        );
        invalido.setUsuarioId("rec-002");

        EntityFormulario form = new EntityFormulario(
                "Formulário Teste",
                "adm-001",
                "evento-123",
                new ArrayList<>()
        );
        formsDTO = new FormularioPreenchidosDTO();
        formsDTO.setFormulariosPreenchidosDtoListForms(List.of(form));

        formsPreenchidos = new EntityFormulariosPreenchidos("",new ArrayList<>());
        formsPreenchidos.setFormularioPreenchidoEventoId("evento-123");
        formsPreenchidos.setFormularioPreenchidoListaFormularios(List.of(form));
    }

    @Test
    void buscarFormByEventoId_ComAdmin_DeveRetornarOk() {
        when(serviceFormulariosPreenchidos.buscarFormualriosPreechidosPorEvento(anyString()))
                .thenReturn(List.of(formsPreenchidos));

        ResponseEntity<List<EntityFormulariosPreenchidos>> response =
                controller.buscarFormByEventoId("evento-123", admin);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertFalse(response.getBody().isEmpty());
        verify(serviceFormulariosPreenchidos).buscarFormualriosPreechidosPorEvento("evento-123");
    }

    @Test
    void buscarFormByEventoId_ComAdminSemFormularios_DeveRetornarNotFound() {
        when(serviceFormulariosPreenchidos.buscarFormualriosPreechidosPorEvento(anyString()))
                .thenReturn(Collections.emptyList());

        ResponseEntity<List<EntityFormulariosPreenchidos>> response =
                controller.buscarFormByEventoId("evento-123", admin);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    void buscarFormByEventoId_SemPermissao_DeveRetornarForbidden() {
        ResponseEntity<List<EntityFormulariosPreenchidos>> response =
                controller.buscarFormByEventoId("evento-123", recrutador);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceFormulariosPreenchidos, never()).buscarFormualriosPreechidosPorEvento(anyString());
    }

    @Test
    void adicionarFormulariosPreenchidos_ComAdmin_DeveRetornarCreated() {
        when(serviceFormulariosPreenchidos.adicionarFomulariosPreenchidos(any()))
                .thenReturn(formsPreenchidos);

        ResponseEntity<EntityFormulariosPreenchidos> response =
                controller.adicionarFormulariosPreenchidos(formsDTO, admin);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertEquals(formsPreenchidos, response.getBody());
        verify(serviceFormulariosPreenchidos).adicionarFomulariosPreenchidos(formsDTO);
    }

    @Test
    void adicionarFormulariosPreenchidos_ComUser_DeveRetornarCreated() {
        when(serviceFormulariosPreenchidos.adicionarFomulariosPreenchidos(any()))
                .thenReturn(formsPreenchidos);

        ResponseEntity<EntityFormulariosPreenchidos> response =
                controller.adicionarFormulariosPreenchidos(formsDTO, recrutador);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        verify(serviceFormulariosPreenchidos).adicionarFomulariosPreenchidos(formsDTO);
    }

    @Test
    void adicionarFormulariosPreenchidos_SemPermissao_DeveRetornarForbidden() {
        ResponseEntity<EntityFormulariosPreenchidos> response =
                controller.adicionarFormulariosPreenchidos(formsDTO, invalido);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceFormulariosPreenchidos, never()).adicionarFomulariosPreenchidos(any());
    }
}

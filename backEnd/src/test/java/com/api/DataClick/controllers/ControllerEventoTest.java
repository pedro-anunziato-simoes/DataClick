package com.api.DataClick.controllers;

import com.api.DataClick.DTO.EventoDTO;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityEvento;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.services.ServiceEvento;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;


import java.util.Collections;
import java.util.Date;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ControllerEventoTest {

    @Mock
    private ServiceEvento serviceEvento;

    @InjectMocks
    private ControllerEvento controller;

    private EntityAdministrador admin;
    private EntityRecrutador recrutador;
    private EntityRecrutador invalido;
    private EntityEvento evento;
    private EventoDTO eventoDTO;

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

        evento = new EntityEvento(
                "admin-123",
                "Evento Teste",
                "Descrição do evento",
                new Date(),
                List.of()
        );
        evento.setEventoId("evento-123");

        eventoDTO = new EventoDTO();
        eventoDTO.setEventoTituloDto("Novo Evento");
        eventoDTO.setEventoDescricaoDto("Nova Descrição");
        eventoDTO.setEventoDataDto(new Date());
    }

    @Test
    void listarEventos_ComAdmin_DeveRetornarListaAdmin() {
        when(serviceEvento.listarEventosPorAdmin(anyString()))
                .thenReturn(List.of(evento));

        ResponseEntity<List<EntityEvento>> response =
                controller.listarTodosEventosPorAdm(admin);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertFalse(response.getBody().isEmpty());
        verify(serviceEvento).listarEventosPorAdmin("adm-001");
    }

    @Test
    void listarEventos_ComRecrutador_DeveRetornarListaRecrutador() {
        when(serviceEvento.listarEventosProRec(anyString()))
                .thenReturn(List.of(evento));

        ResponseEntity<List<EntityEvento>> response =
                controller.listarTodosEventosPorAdm(recrutador);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        verify(serviceEvento).listarEventosProRec("rec-001");
    }

    @Test
    void buscarEvento_ComPermissao_DeveRetornarEvento() {
        when(serviceEvento.buscarEventoById(anyString()))
                .thenReturn(evento);

        ResponseEntity<EntityEvento> response =
                controller.buscarEvento("evento-123", admin);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(evento, response.getBody());
    }

    @Test
    void buscarEvento_SemPermissao_DeveRetornarForbidden() {
        ResponseEntity<EntityEvento> response =
                controller.buscarEvento("evento-123", invalido);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceEvento, never()).buscarEventoById(anyString());
    }
    @Test
    void alterarEvento_ComAdmin_DeveRetornarEventoAtualizado() {
        when(serviceEvento.alterarEvento(anyString(), any()))
                .thenReturn(evento);

        ResponseEntity<EntityEvento> response =
                controller.alterarEvento(eventoDTO, "evento-123", admin);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        verify(serviceEvento).alterarEvento("evento-123", eventoDTO);
    }


    @Test
    void alterarEvento_SemPermissao_DeveRetornarForbidden() {
        ResponseEntity<EntityEvento> response =
                controller.alterarEvento(eventoDTO, "evento-123", recrutador);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
    }

    @Test
    void criarEvento_ComAdmin_DeveRetornarCriado() {
        when(serviceEvento.crirarEvento(any(), anyString()))
                .thenReturn(evento);

        ResponseEntity<EntityEvento> response =
                controller.criarEvento(eventoDTO, admin);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        verify(serviceEvento).crirarEvento(eventoDTO, "adm-001");
    }

    @Test
    void criarEvento_SemPermissao_DeveRetornarForbidden() {
        ResponseEntity<EntityEvento> response =
                controller.criarEvento(eventoDTO, recrutador);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
    }

    @Test
    void removerEvento_ComAdmin_DeveRetornarSucesso() {
        ResponseEntity<Void> response =
                controller.removerEvento("evento-123", admin);

        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
        verify(serviceEvento).removerEvento("evento-123");
    }

    @Test
    void removerEvento_SemPermissao_DeveRetornarForbidden() {
        ResponseEntity<Void> response =
                controller.removerEvento("evento-123", recrutador);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
    }
}

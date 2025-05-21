package com.api.DataClick.services;

import com.api.DataClick.DTO.FormularioDTO;
import com.api.DataClick.entities.*;
import com.api.DataClick.enums.TipoCampo;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryCampo;
import com.api.DataClick.repositories.RepositoryEvento;
import com.api.DataClick.repositories.RepositoryFormulario;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

public class ServiceFormularioTest {

    @Mock
    private RepositoryFormulario repositoryFormulario;
    @Mock
    private RepositoryAdministrador repositoryAdministrador;
    @Mock
    private RepositoryRecrutador repositoryRecrutador;
    @Mock
    private RepositoryCampo repositoryCampo;
    @Mock
    private RepositoryEvento repositoryEvento;

    @InjectMocks
    private ServiceFormulario serviceFormulario;

    private FormularioDTO formularioDTO;
    private EntityEvento evento;
    private EntityAdministrador admin;
    private EntityFormulario formulario;

//    @BeforeEach
//    void setUp() {
//        MockitoAnnotations.openMocks(this);
//
//        formularioDTO = mock(FormularioDTO.class);
//        when(formularioDTO.getFormularioTituloDto()).thenReturn("Formulario Teste");
//
//        admin = new EntityAdministrador(
//                "cnpjAdmin",
//                "Admin Teste",
//                "senhaAdmin",
//                "111111111",
//                "admin@example.com",
//                UserRole.ADMIN
//        );
//        admin.setUsuarioId("adminId1");
//        admin.setAdminEventos(new ArrayList<>());
//        admin.setAdminRecrutadores(new ArrayList<>());
//
//
//        evento = new EntityEvento("adminId1", "Evento Teste", "Descrição", new Date(), new ArrayList<>());
//        evento.setEventoId("eventoId1");
//        evento.setEventoAdminId("adminId1");
//
//        formulario = new EntityFormulario("adminId1", "Formulario Existente");
//        formulario.setFormId("formId1");
//        formulario.setCampos(new ArrayList<>());
//    }
//
//    @Test
//    void criarFormulario_shouldCreateAndReturnFormulario_whenEventoAndAdminExist() {
//        when(repositoryEvento.findById("eventoId1")).thenReturn(Optional.of(evento));
//        when(repositoryAdministrador.findById("adminId1")).thenReturn(Optional.of(admin));
//        when(repositoryFormulario.save(any(EntityFormulario.class))).thenAnswer(invocation -> {
//            EntityFormulario savedForm = invocation.getArgument(0);
//            savedForm.setFormId("newFormId");
//            return savedForm;
//        });
//        when(repositoryEvento.save(any(EntityEvento.class))).thenReturn(evento);
//
//        EntityFormulario result = serviceFormulario.criarFormulario(formularioDTO, "eventoId1");
//
//        assertNotNull(result);
//        assertEquals("Formulario Teste", result.getFormularioTitulo());
//        assertEquals("adminId1", result.getFormAdminId());
//        assertTrue(evento.getEventoFormularios().contains(result));
//
//        verify(repositoryEvento, times(1)).findById("eventoId1");
//        verify(repositoryAdministrador, times(1)).findById("adminId1");
//        verify(repositoryFormulario, times(1)).save(any(EntityFormulario.class));
//        verify(repositoryEvento, times(1)).save(evento);
//    }

    @Test
    void criarFormulario_shouldThrowException_whenEventoNotFound() {
        when(repositoryEvento.findById("nonExistentEventoId")).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceFormulario.criarFormulario(formularioDTO, "nonExistentEventoId");
        });

        verify(repositoryEvento, times(1)).findById("nonExistentEventoId");
        verify(repositoryAdministrador, never()).findById(anyString());
        verify(repositoryFormulario, never()).save(any(EntityFormulario.class));
    }

    @Test
    void criarFormulario_shouldThrowException_whenAdminNotFound() {
        when(repositoryEvento.findById("eventoId1")).thenReturn(Optional.of(evento));
        when(repositoryAdministrador.findById("adminId1")).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceFormulario.criarFormulario(formularioDTO, "eventoId1");
        });

        verify(repositoryEvento, times(1)).findById("eventoId1");
        verify(repositoryAdministrador, times(1)).findById("adminId1");
        verify(repositoryFormulario, never()).save(any(EntityFormulario.class));
    }

//    @Test
//    void removerFormulario_shouldRemoveFormularioAndAssociations_whenFormExists() {
//        EntityCampo campo = new EntityCampo("Campo Teste", TipoCampo.TEXTO);
//        campo.setCampoId("campoId1");
//        formulario.getCampos().add(campo);
//        evento.getEventoFormularios().add(formulario);
//        admin.getAdminEventos().add(evento);
//
//        when(repositoryFormulario.findById("formId1")).thenReturn(Optional.of(formulario));
//        when(repositoryAdministrador.findById("adminId1")).thenReturn(Optional.of(admin));
//        when(repositoryEvento.findById(evento.getEventoId())).thenReturn(Optional.of(evento));
//
//        doNothing().when(repositoryCampo).delete(any(EntityCampo.class));
//        doNothing().when(repositoryFormulario).delete(any(EntityFormulario.class));
//        when(repositoryEvento.save(any(EntityEvento.class))).thenReturn(evento);
//        when(repositoryAdministrador.save(any(EntityAdministrador.class))).thenReturn(admin);
//
//        serviceFormulario.removerFormulario("formId1");
//
//        verify(repositoryFormulario, times(1)).findById("formId1");
//        verify(repositoryCampo, times(1)).delete(campo);
//        verify(repositoryAdministrador, times(1)).findById("adminId1");
//        verify(repositoryFormulario, times(2)).delete(any(EntityFormulario.class));
//        verify(repositoryEvento, atLeastOnce()).save(any(EntityEvento.class));
//        verify(repositoryAdministrador, times(1)).save(admin);
//    }

    @Test
    void removerFormulario_shouldThrowException_whenFormNotFound() {
        when(repositoryFormulario.findById("nonExistentFormId")).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceFormulario.removerFormulario("nonExistentFormId");
        });
        verify(repositoryFormulario, times(1)).findById("nonExistentFormId");
        verify(repositoryCampo, never()).delete(any(EntityCampo.class));
    }

    @Test
    void bucarFormPorId_shouldReturnFormulario_whenFormularioExists() {
        when(repositoryFormulario.findById("formId1")).thenReturn(Optional.of(formulario));

        EntityFormulario result = serviceFormulario.bucarFormPorId("formId1");

        assertNotNull(result);
        assertEquals(formulario, result);
        verify(repositoryFormulario, times(1)).findById("formId1");
    }

    @Test
    void bucarFormPorId_shouldThrowException_whenFormularioNotFound() {
        when(repositoryFormulario.findById("nonExistentFormId")).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceFormulario.bucarFormPorId("nonExistentFormId");
        });
        verify(repositoryFormulario, times(1)).findById("nonExistentFormId");
    }

    @Test
    void ListarFormPorEventoId_shouldReturnListOfFormularios_whenEventoExists() {
        evento.getEventoFormularios().add(formulario);
        when(repositoryEvento.findById("eventoId1")).thenReturn(Optional.of(evento));

        List<EntityFormulario> result = serviceFormulario.ListarFormPorEventoId("eventoId1");

        assertNotNull(result);
        assertFalse(result.isEmpty());
        assertEquals(1, result.size());
        assertEquals(formulario, result.get(0));
        verify(repositoryEvento, times(1)).findById("eventoId1");
    }

    @Test
    void ListarFormPorEventoId_shouldThrowException_whenEventoNotFound() {
        when(repositoryEvento.findById("nonExistentEventoId")).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceFormulario.ListarFormPorEventoId("nonExistentEventoId");
        });
        verify(repositoryEvento, times(1)).findById("nonExistentEventoId");
    }

    @Test
    void alterarFormulario_shouldUpdateAndReturnFormulario_whenFormularioExists() {
        FormularioDTO updatedDto = mock(FormularioDTO.class);
        when(updatedDto.getFormularioTituloDto()).thenReturn("Formulario Atualizado");

        when(repositoryFormulario.findById("formId1")).thenReturn(Optional.of(formulario));
        when(repositoryFormulario.save(any(EntityFormulario.class))).thenAnswer(invocation -> invocation.getArgument(0));

        EntityFormulario result = serviceFormulario.alterarFormulario(updatedDto, "formId1");

        assertNotNull(result);
        assertEquals("Formulario Atualizado", result.getFormularioTitulo());
        verify(repositoryFormulario, times(1)).findById("formId1");
        verify(repositoryFormulario, times(1)).save(formulario);
    }

    @Test
    void alterarFormulario_shouldThrowException_whenFormularioNotFound() {
        FormularioDTO updatedDto = mock(FormularioDTO.class);
        when(updatedDto.getFormularioTituloDto()).thenReturn("Formulario Atualizado");

        when(repositoryFormulario.findById("nonExistentFormId")).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceFormulario.alterarFormulario(updatedDto, "nonExistentFormId");
        });
        verify(repositoryFormulario, times(1)).findById("nonExistentFormId");
        verify(repositoryFormulario, never()).save(any(EntityFormulario.class));
    }

//    @Test
//    void criarFormulario_DeveAtualizarRecrutadores_QuandoExistemRecrutadoresAssociados() {
//        EntityRecrutador recrutador1 = new EntityRecrutador(
//                "Recrutador 1", "senha1", "11999991111",
//                "rec1@empresa.com", "adminId1", UserRole.USER, new ArrayList<>()
//        );
//
//        EntityRecrutador recrutador2 = new EntityRecrutador(
//                "Recrutador 2", "senha2", "11999992222",
//                "rec2@empresa.com", "adminId1", UserRole.USER, new ArrayList<>()
//        );
//
//        admin.getAdminRecrutadores().addAll(List.of(recrutador1, recrutador2));
//
//        when(repositoryEvento.findById("eventoId1")).thenReturn(Optional.of(evento));
//        when(repositoryAdministrador.findById("adminId1")).thenReturn(Optional.of(admin));
//        when(repositoryFormulario.save(any())).thenAnswer(inv -> {
//            EntityFormulario f = inv.getArgument(0);
//            f.setFormId("formIdNovo");
//            return f;
//        });
//        when(repositoryRecrutador.save(any())).thenAnswer(inv -> inv.getArgument(0));
//
//        serviceFormulario.criarFormulario(formularioDTO, "eventoId1");
//
//        ArgumentCaptor<EntityRecrutador> captor = ArgumentCaptor.forClass(EntityRecrutador.class);
//        verify(repositoryRecrutador, times(2)).save(captor.capture());
//
//        List<EntityRecrutador> recruitersSalvos = captor.getAllValues();
//
//        assertAll(
//                () -> assertEquals(2, recruitersSalvos.size(), "Deve salvar 2 recrutadores"),
//                () -> assertTrue(recruitersSalvos.contains(recrutador1), "Recrutador 1 não foi salvo"),
//                () -> assertTrue(recruitersSalvos.contains(recrutador2), "Recrutador 2 não foi salvo"),
//                () -> assertTrue(recrutador1.getRecrutadorEventos().contains(evento), "Evento não associado ao Recrutador 1"),
//                () -> assertTrue(recrutador2.getRecrutadorEventos().contains(evento), "Evento não associado ao Recrutador 2")
//        );
//    }
}

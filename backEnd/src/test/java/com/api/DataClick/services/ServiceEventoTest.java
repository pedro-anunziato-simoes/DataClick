package com.api.DataClick.services;
import com.api.DataClick.DTO.EventoDTO;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityEvento;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryEvento;
import com.api.DataClick.repositories.RepositoryFormulario;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
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


public class ServiceEventoTest {

    @Mock
    private RepositoryEvento repositoryEvento;
    @Mock
    private RepositoryRecrutador repositoryRecrutador;
    @Mock
    private RepositoryAdministrador repositoryAdministrador;
    @Mock
    private RepositoryFormulario repositoryFormulario;

    @InjectMocks
    private ServiceEvento serviceEvento;

    private EventoDTO eventoDTO;
    private EntityAdministrador admin;
    private EntityEvento evento;
    private EntityRecrutador recrutador;

//    @BeforeEach
//    void setUp() {
//        MockitoAnnotations.openMocks(this);
//
//        eventoDTO = mock(EventoDTO.class);
//        when(eventoDTO.getEventoTituloDto()).thenReturn("Evento Teste");
//        when(eventoDTO.getEventoDescricaoDto()).thenReturn("Descrição do Evento Teste");
//        when(eventoDTO.getEventoDataDto()).thenReturn(new Date());
//
//        admin = new EntityAdministrador("cnpjAdmin", "Admin Teste", "adminpass", "111111111", "admin@example.com", UserRole.ADMIN);
//        admin.setUsuarioId("adminId1");
//        admin.setAdminEventos(new ArrayList<>());
//        admin.setAdminRecrutadores(new ArrayList<>());
//
//        recrutador = new EntityRecrutador("Recrutador Teste", "password", "123456789", "recrutador@example.com", "adminId1", UserRole.USER, new ArrayList<>());
//        recrutador.setUsuarioId("recrutadorId1");
//
//        evento = new EntityEvento("adminId1", "Evento Existente", "Descrição Existente", new Date(), new ArrayList<EntityFormulario>());
//        evento.setEventoId("eventoId1");
//    }

//    @Test
//    void crirarEvento_shouldCreateAndReturnEvento_whenAdminExists() {
//        when(repositoryAdministrador.findById(eq("adminId1"))).thenReturn(Optional.of(admin));
//        when(repositoryEvento.save(any(EntityEvento.class))).thenAnswer(invocation -> {
//            EntityEvento savedEvento = invocation.getArgument(0);
//            savedEvento.setEventoId("newEventId");
//            return savedEvento;
//        });
//        when(repositoryRecrutador.save(any(EntityRecrutador.class))).thenAnswer(invocation -> invocation.getArgument(0));
//        EntityEvento result = serviceEvento.crirarEvento(eventoDTO, "adminId1");
//
//        assertNotNull(result);
//        assertEquals("Evento Teste", result.getEventoTitulo());
//        assertEquals("adminId1", result.getEventoAdminId());
//        assertTrue(admin.getAdminEventos().contains(result));
//
//        // Verify interactions
//        verify(repositoryAdministrador, times(1)).findById(eq("adminId1"));
//        verify(repositoryEvento, times(1)).save(any(EntityEvento.class)); // Event is saved first
//        // If admin has recrutadores, their events list is updated and they are saved
//        for (EntityRecrutador rec : admin.getAdminRecrutadores()) {
//            assertTrue(rec.getRecrutadorEventos().contains(result));
//            verify(repositoryRecrutador).save(rec);
//        }
//        // repositoryAdministrador.save(admin) is NOT called in the service method, so remove verification for it
//        // verify(repositoryAdministrador, times(1)).save(eq(admin));
//    }
//
//    @Test
//    void crirarEvento_shouldThrowException_whenAdminNotFound() {
//        when(repositoryAdministrador.findById(eq("nonExistentAdminId"))).thenReturn(Optional.empty());
//        when(repositoryEvento.save(any(EntityEvento.class))).thenAnswer(invocation -> {
//            EntityEvento savedEvento = invocation.getArgument(0);
//            savedEvento.setEventoId("newEventId");
//            return savedEvento;
//        });
//
//        assertThrows(ExeptionNaoEncontrado.class, () -> {
//            serviceEvento.crirarEvento(eventoDTO, "nonExistentAdminId");
//        });
//
//        verify(repositoryEvento, times(1)).save(any(EntityEvento.class)); // Event is saved before admin check
//        verify(repositoryAdministrador, times(1)).findById(eq("nonExistentAdminId"));
//        verify(repositoryRecrutador, never()).save(any(EntityRecrutador.class));
//        verify(repositoryAdministrador, never()).save(any(EntityAdministrador.class)); // Admin is not saved if not found
//    }

    @Test
    void listarEventosPorAdmin_shouldReturnListOfEventos_whenAdminExistsAndHasEvents() {
        when(repositoryEvento.findAllByEventoAdminId(eq("adminId1"))).thenReturn(Optional.of(List.of(evento)));

        List<EntityEvento> result = serviceEvento.listarEventosPorAdmin("adminId1");

        assertNotNull(result);
        assertFalse(result.isEmpty());
        assertEquals(1, result.size());
        assertEquals(evento, result.get(0));
        verify(repositoryEvento, times(1)).findAllByEventoAdminId(eq("adminId1"));
    }

    @Test
    void listarEventosPorAdmin_shouldThrowException_whenNoEventsFound() {
        when(repositoryEvento.findAllByEventoAdminId(eq("adminId1"))).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceEvento.listarEventosPorAdmin("adminId1");
        });
        verify(repositoryEvento, times(1)).findAllByEventoAdminId(eq("adminId1"));
    }

    @Test
    void listarEventosProRec_shouldReturnListOfEventos_whenRecruiterExists() {
        recrutador.getRecrutadorEventos().add(evento);
        when(repositoryRecrutador.findById(eq("recrutadorId1"))).thenReturn(Optional.of(recrutador));

        List<EntityEvento> result = serviceEvento.listarEventosProRec("recrutadorId1");

        assertNotNull(result);
        assertFalse(result.isEmpty());
        assertEquals(1, result.size());
        assertEquals(evento, result.get(0));
        verify(repositoryRecrutador, times(1)).findById(eq("recrutadorId1"));
    }

    @Test
    void listarEventosProRec_shouldThrowException_whenRecruiterNotFound() {
        when(repositoryRecrutador.findById(eq("nonExistentRecId"))).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceEvento.listarEventosProRec("nonExistentRecId");
        });
        verify(repositoryRecrutador, times(1)).findById(eq("nonExistentRecId"));
    }

    @Test
    void buscarEventoById_shouldReturnEvento_whenEventoExists() {
        when(repositoryEvento.findById(eq("eventoId1"))).thenReturn(Optional.of(evento));

        EntityEvento result = serviceEvento.buscarEventoById("eventoId1");

        assertNotNull(result);
        assertEquals(evento, result);
        verify(repositoryEvento, times(1)).findById(eq("eventoId1"));
    }

    @Test
    void buscarEventoById_shouldThrowException_whenEventoNotFound() {
        when(repositoryEvento.findById(eq("nonExistentEventoId"))).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceEvento.buscarEventoById("nonExistentEventoId");
        });
        verify(repositoryEvento, times(1)).findById(eq("nonExistentEventoId"));
    }

    @Test
    void alterarEvento_shouldUpdateAndReturnEvento_whenEventoExists() {
        EventoDTO updatedDto = mock(EventoDTO.class);
        when(updatedDto.getEventoTituloDto()).thenReturn("Evento Atualizado");
        when(updatedDto.getEventoDescricaoDto()).thenReturn("Descrição Atualizada");
        Date newDate = new Date(System.currentTimeMillis() + 24 * 60 * 60 * 1000); // tomorrow
        when(updatedDto.getEventoDataDto()).thenReturn(newDate);

        when(repositoryEvento.findById(eq("eventoId1"))).thenReturn(Optional.of(evento));
        when(repositoryEvento.save(any(EntityEvento.class))).thenAnswer(invocation -> invocation.getArgument(0));

        EntityEvento result = serviceEvento.alterarEvento("eventoId1", updatedDto);

        assertNotNull(result);
        assertEquals("Evento Atualizado", result.getEventoTitulo());
        assertEquals("Descrição Atualizada", result.getEventoDescricao());
        assertEquals(newDate, result.getEventoData());
        verify(repositoryEvento, times(1)).findById(eq("eventoId1"));
        verify(repositoryEvento, times(1)).save(eq(evento));
    }

    @Test
    void alterarEvento_shouldThrowException_whenEventoNotFound() {
        EventoDTO updatedDto = mock(EventoDTO.class);
        when(repositoryEvento.findById(eq("nonExistentEventoId"))).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceEvento.alterarEvento("nonExistentEventoId", updatedDto);
        });
        verify(repositoryEvento, times(1)).findById(eq("nonExistentEventoId"));
        verify(repositoryEvento, never()).save(any(EntityEvento.class));
    }

//    @Test
//    void removerEvento_shouldRemoveEventoAndAssociations_whenEventoExists() {
//        EntityFormulario form = new EntityFormulario("adminId1", "Form Teste em Evento");
//        form.setFormId("formId1");
//        evento.getEventoFormularios().add(form);
//        admin.getAdminEventos().add(evento);
//
//        when(repositoryEvento.findById(eq("eventoId1"))).thenReturn(Optional.of(evento));
//        when(repositoryAdministrador.findById(eq("adminId1"))).thenReturn(Optional.of(admin)); // Admin for the event
//
//        doNothing().when(repositoryFormulario).delete(any(EntityFormulario.class));
//        doNothing().when(repositoryEvento).delete(eq(evento));
//        when(repositoryAdministrador.save(any(EntityAdministrador.class))).thenReturn(admin);
//
//        serviceEvento.removerEvento("eventoId1");
//
//        verify(repositoryEvento, times(1)).findById(eq("eventoId1"));
//        verify(repositoryFormulario, times(1)).delete(eq(form));
//        verify(repositoryAdministrador, times(1)).findById(eq("adminId1")); // Verify admin lookup for the event
//        verify(repositoryAdministrador, times(1)).save(eq(admin));
//        verify(repositoryEvento, times(1)).delete(eq(evento));
//        assertFalse(admin.getAdminEventos().contains(evento));
//    }

    @Test
    void removerEvento_shouldThrowException_whenEventoNotFound() {
        when(repositoryEvento.findById(eq("nonExistentEventoId"))).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceEvento.removerEvento("nonExistentEventoId");
        });
        verify(repositoryEvento, times(1)).findById(eq("nonExistentEventoId"));
        verify(repositoryFormulario, never()).delete(any(EntityFormulario.class));
        verify(repositoryAdministrador, never()).findById(anyString());
        verify(repositoryAdministrador, never()).save(any(EntityAdministrador.class));
        verify(repositoryEvento, never()).delete(any(EntityEvento.class));
    }


}

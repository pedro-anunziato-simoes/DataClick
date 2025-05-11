package com.api.DataClick.services;



import com.api.DataClick.entities.EntityFormulariosPreenchidos;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryFormualriosPreenchidos;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;


public class ServiceFormulariosPreenchidosTest {


    @Mock
    private RepositoryFormualriosPreenchidos repositoryFormulariosPreenchidos; // Corrected typo here

    @Mock
    private RepositoryRecrutador repositoryRecrutador;

    @InjectMocks
    private ServiceFormulariosPreenchidos serviceFormulariosPreenchidos;

    private EntityRecrutador recrutador;
    private EntityFormulariosPreenchidos formularioPreenchido;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        recrutador = new EntityRecrutador(
                "Recrutador Teste",
                "password",
                "123456789",
                "recrutador@example.com",
                "adminId1",
                UserRole.USER,
                new ArrayList<>()
        );
        recrutador.setUsuarioId("recrutadorId1");

        formularioPreenchido = new EntityFormulariosPreenchidos(new ArrayList<>() );
        formularioPreenchido.setFormulariosPreId("formPreenchidoId1");
        formularioPreenchido.setRecrutadorId("recrutadorId1");
        formularioPreenchido.setFormularioPreenchidoAdminId("adminId1");

    }


    @Test
    void buscarListaDeFormualriosPorIdRecrutador_shouldReturnListOfForms_whenRecruiterAndFormsExist() {
        when(repositoryRecrutador.findById("recrutadorId1")).thenReturn(Optional.of(recrutador));
        when(repositoryFormulariosPreenchidos.findByrecrutadorId("recrutadorId1")).thenReturn(Optional.of(List.of(formularioPreenchido)));

        List<EntityFormulariosPreenchidos> result = serviceFormulariosPreenchidos.buscarListaDeFormualriosPorIdRecrutador("recrutadorId1");

        assertNotNull(result);
        assertFalse(result.isEmpty());
        assertEquals(1, result.size());
        assertEquals(formularioPreenchido, result.get(0));
        verify(repositoryRecrutador, times(1)).findById("recrutadorId1");
        verify(repositoryFormulariosPreenchidos, times(1)).findByrecrutadorId("recrutadorId1");
    }

    @Test
    void buscarListaDeFormualriosPorIdRecrutador_shouldThrowException_whenRecruiterNotFound() {
        when(repositoryRecrutador.findById("nonExistentRecId")).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceFormulariosPreenchidos.buscarListaDeFormualriosPorIdRecrutador("nonExistentRecId");
        });

        verify(repositoryRecrutador, times(1)).findById("nonExistentRecId");
        verify(repositoryFormulariosPreenchidos, never()).findByrecrutadorId(anyString());
    }

    @Test
    void buscarListaDeFormualriosPorIdRecrutador_shouldThrowException_whenFormsNotFoundForRecruiter() {
        when(repositoryRecrutador.findById("recrutadorId1")).thenReturn(Optional.of(recrutador));
        when(repositoryFormulariosPreenchidos.findByrecrutadorId("recrutadorId1")).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceFormulariosPreenchidos.buscarListaDeFormualriosPorIdRecrutador("recrutadorId1");
        });

        verify(repositoryRecrutador, times(1)).findById("recrutadorId1");
        verify(repositoryFormulariosPreenchidos, times(1)).findByrecrutadorId("recrutadorId1");
    }
}

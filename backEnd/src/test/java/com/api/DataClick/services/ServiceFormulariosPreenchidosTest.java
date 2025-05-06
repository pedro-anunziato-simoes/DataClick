package com.api.DataClick.services;

import com.api.DataClick.entities.EntityFormulariosPreenchidos;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryFormualriosPreenchidos;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@SpringBootTest
public class ServiceFormulariosPreenchidosTest {


    @Mock
    private RepositoryFormualriosPreenchidos repositoryFormualriosPreenchidos;

    @Mock
    private RepositoryRecrutador repositoryRecrutador;

    @InjectMocks
    private ServiceFormulariosPreenchidos serviceFormulariosPreenchidos;

    private EntityFormulariosPreenchidos formularioPreenchido;
    private EntityRecrutador recrutador;
    private EntityFormulario formulario;

    @BeforeEach
    void setUp() {
        formulario = new EntityFormulario("adminId123", "Formulario Teste");
        formularioPreenchido = new EntityFormulariosPreenchidos(Arrays.asList(formulario));
        recrutador = new EntityRecrutador("recrutador1", "senha", "telefone", "email", "adminId123", Arrays.asList(), null);
    }

    @Test
    void testAdicionarFormularioPreenchido() {
        when(repositoryRecrutador.findById("recrutadorId123")).thenReturn(java.util.Optional.of(recrutador));
        when(repositoryFormualriosPreenchidos.save(formularioPreenchido)).thenReturn(formularioPreenchido);

        EntityFormulariosPreenchidos result = serviceFormulariosPreenchidos.adicionarFormulariosPreenchidos(formularioPreenchido, "recrutadorId123");

        verify(repositoryRecrutador, times(1)).findById("recrutadorId123");
        verify(repositoryFormualriosPreenchidos, times(1)).save(formularioPreenchido);

        assertNotNull(result);
        assertEquals("formPreId123", result.getFormulariosPreId());
    }

    @Test
    void testBuscarListaDeFormulariosPorIdRecrutador() {
        when(repositoryRecrutador.findById("recrutadorId123")).thenReturn(java.util.Optional.of(recrutador));
        when(repositoryFormualriosPreenchidos.findByrecrutadorId("recrutadorId123"))
                .thenReturn(java.util.Optional.of(Arrays.asList(formularioPreenchido)));

        List<EntityFormulariosPreenchidos> result = serviceFormulariosPreenchidos.buscarListaDeFormualriosPorIdRecrutador("recrutadorId123");

        assertNotNull(result);
        assertFalse(result.isEmpty());
        assertEquals("formPreId123", result.get(0).getFormulariosPreId());
    }

    @Test
    void testAdicionarFormularioPreenchidoRecrutadorNaoEncontrado() {
        when(repositoryRecrutador.findById("recrutadorId123")).thenReturn(java.util.Optional.empty());

        Exception exception = assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceFormulariosPreenchidos.adicionarFormulariosPreenchidos(formularioPreenchido, "recrutadorId123");
        });

        assertEquals(ExeceptionsMensage.REC_NAO_ENCONTRADO, exception.getMessage());
    }

    @Test
    void testBuscarListaDeFormulariosPorIdRecrutadorNaoEncontrado() {
        when(repositoryRecrutador.findById("recrutadorId123")).thenReturn(java.util.Optional.empty());

        Exception exception = assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceFormulariosPreenchidos.buscarListaDeFormualriosPorIdRecrutador("recrutadorId123");
        });

        assertEquals(ExeceptionsMensage.REC_NAO_ENCONTRADO, exception.getMessage());
    }
}

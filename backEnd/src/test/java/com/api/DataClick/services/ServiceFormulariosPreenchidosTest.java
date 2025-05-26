package com.api.DataClick.services;



import com.api.DataClick.entities.EntityFormulario;
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
    private RepositoryFormualriosPreenchidos repositoryFormulariosPreenchidos;

    @Mock
    private RepositoryRecrutador repositoryRecrutador;

    @InjectMocks
    private ServiceFormulariosPreenchidos serviceFormulariosPreenchidos;

    private EntityRecrutador recrutador;
    private EntityFormulariosPreenchidos formularioPreenchido;


    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        List<EntityFormulario> listaFormularios = new ArrayList<>();
        EntityFormulario form = new EntityFormulario("FormTest", "adminId1", "Formulario Pai", null);
        form.setFormularioEventoId("evento123");
        listaFormularios.add(form);

        formularioPreenchido = new EntityFormulariosPreenchidos("evento123", listaFormularios);
        formularioPreenchido.setFormulariosPreId("formPreenchidoId1");
    }

    @Test
    void buscarFormulariosPreenchidosPorEvento_DeveRetornarLista_QuandoEventoExiste() {
        when(repositoryFormulariosPreenchidos.findByformularioPreenchidoEventoId("evento123"))
                .thenReturn(Optional.of(List.of(formularioPreenchido)));

        List<EntityFormulariosPreenchidos> resultado = serviceFormulariosPreenchidos.buscarFormualriosPreechidosPorEvento("evento123");

        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        assertEquals("evento123", resultado.get(0).getFormularioPreenchidoEventoId());
        verify(repositoryFormulariosPreenchidos, times(1)).findByformularioPreenchidoEventoId("evento123");
    }

    @Test
    void buscarFormulariosPreenchidosPorEvento_DeveLancarExcecao_QuandoEventoNaoExiste() {
        when(repositoryFormulariosPreenchidos.findByformularioPreenchidoEventoId("eventoInexistente"))
                .thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceFormulariosPreenchidos.buscarFormualriosPreechidosPorEvento("eventoInexistente");
        });

        verify(repositoryFormulariosPreenchidos, times(1)).findByformularioPreenchidoEventoId("eventoInexistente");
    }

    @Test
    void adicionarFomulariosPreenchidos_DeveSalvarComEventoExtraidoCorretamente() {
        List<EntityFormulario> lista = new ArrayList<>();
        EntityFormulario form = new EntityFormulario("FormTest", "adminId1", "Formulario Pai", null);
        form.setFormularioEventoId("evento456");
        lista.add(form);

        EntityFormulariosPreenchidos expectedSaved = new EntityFormulariosPreenchidos("evento456", lista);

        when(repositoryFormulariosPreenchidos.save(any(EntityFormulariosPreenchidos.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        var dto = new com.api.DataClick.DTO.FormularioPreenchidosDTO();
        dto.setFormulariosPreenchidosDtoListForms(lista);

        EntityFormulariosPreenchidos resultado = serviceFormulariosPreenchidos.adicionarFomulariosPreenchidos(dto);

        assertNotNull(resultado);
        assertEquals("evento456", resultado.getFormularioPreenchidoEventoId());
        assertEquals(1, resultado.getFormularioPreenchidoListaFormularios().size());
        verify(repositoryFormulariosPreenchidos, times(1)).save(any(EntityFormulariosPreenchidos.class));
    }
}

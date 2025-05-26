package com.api.DataClick.services;


import com.api.DataClick.DTO.CampoDTO;
import com.api.DataClick.entities.EntityCampo;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.enums.TipoCampo;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryCampo;
import com.api.DataClick.repositories.RepositoryFormulario;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

public class ServiceCampoTest {
    @Mock
    private RepositoryCampo repositoryCampo;

    @Mock
    private RepositoryFormulario repositoryFormulario;

    @InjectMocks
    private ServiceCampo serviceCampo;

    private CampoDTO campoDTO;
    private EntityFormulario formulario;
    private EntityCampo campo;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        campoDTO = mock(CampoDTO.class);
        when(campoDTO.getCampoTituloDto()).thenReturn("Campo Teste");
        when(campoDTO.getCampoTipoDto()).thenReturn(TipoCampo.TEXTO);

        formulario = new EntityFormulario("FormTest", "adminId1", "Formulario Pai", null);
        formulario.setFormId("formId1");
        formulario.setCampos(new ArrayList<>());

        campo = new EntityCampo("Campo Existente", TipoCampo.NUMERO, null);
        campo.setCampoId("campoId1");
        campo.setCampoFormId("formId1");
    }

    @Test
    void adicionarCampo_shouldCreateAndReturnCampo_whenFormularioExists() {
        when(repositoryFormulario.findById("formId1")).thenReturn(Optional.of(formulario));
        when(repositoryCampo.save(any(EntityCampo.class))).thenAnswer(invocation -> {
            EntityCampo savedCampo = invocation.getArgument(0);
            savedCampo.setCampoId("newCampoId");
            return savedCampo;
        });
        when(repositoryFormulario.save(any(EntityFormulario.class))).thenReturn(formulario);

        EntityCampo result = serviceCampo.adicionarCampo(campoDTO, "formId1");

        assertNotNull(result);
        assertEquals("Campo Teste", result.getCampoTitulo());
        assertEquals(TipoCampo.TEXTO, result.getCampoTipo());
        assertEquals("formId1", result.getCampoFormId());
        assertTrue(formulario.getCampos().contains(result));

        verify(repositoryFormulario, times(1)).findById("formId1");
        verify(repositoryCampo, times(1)).save(any(EntityCampo.class));
        verify(repositoryFormulario, times(1)).save(formulario);
    }

    @Test
    void adicionarCampo_shouldThrowException_whenFormularioNotFound() {
        when(repositoryFormulario.findById("nonExistentFormId")).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceCampo.adicionarCampo(campoDTO, "nonExistentFormId");
        });

        verify(repositoryFormulario, times(1)).findById("nonExistentFormId");
        verify(repositoryCampo, never()).save(any(EntityCampo.class));
    }

    @Test
    void removerCampo_shouldRemoveCampo_whenCampoExists() { // Test name and logic corrected
        when(repositoryCampo.findById("campoId1")).thenReturn(Optional.of(campo));
        doNothing().when(repositoryCampo).delete(campo);

        serviceCampo.removerCampo("campoId1");

        verify(repositoryCampo, times(1)).findById("campoId1");
        verify(repositoryCampo, times(1)).delete(campo);
        verifyNoInteractions(repositoryFormulario);
    }

    @Test
    void removerCampo_shouldThrowException_whenCampoNotFound() {
        when(repositoryCampo.findById("nonExistentCampoId")).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceCampo.removerCampo("nonExistentCampoId");
        });
        verify(repositoryCampo, times(1)).findById("nonExistentCampoId");
        verify(repositoryFormulario, never()).findById(anyString());
        verify(repositoryCampo, never()).delete(any(EntityCampo.class));
    }

    @Test
    void buscarCampoById_shouldReturnCampo_whenCampoExists() {
        when(repositoryCampo.findById("campoId1")).thenReturn(Optional.of(campo));
        EntityCampo result = serviceCampo.buscarCampoById("campoId1");

        assertNotNull(result);
        assertEquals(campo, result);
        verify(repositoryCampo, times(1)).findById("campoId1");
    }

    @Test
    void buscarCampoById_shouldThrowException_whenCampoNotFound() {
        when(repositoryCampo.findById("nonExistentCampoId")).thenReturn(Optional.empty());
        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceCampo.buscarCampoById("nonExistentCampoId");
        });
        verify(repositoryCampo, times(1)).findById("nonExistentCampoId");
    }

    @Test
    void alterarCampo_shouldUpdateAndReturnCampo_whenCampoExists() {
        CampoDTO updatedDto = mock(CampoDTO.class);
        when(updatedDto.getCampoTituloDto()).thenReturn("Campo Atualizado");
        when(updatedDto.getCampoTipoDto()).thenReturn(TipoCampo.DATA);

        when(repositoryCampo.findById("campoId1")).thenReturn(Optional.of(campo));
        when(repositoryCampo.save(any(EntityCampo.class))).thenAnswer(invocation -> invocation.getArgument(0));

        EntityCampo result = serviceCampo.alterarCampo("campoId1", updatedDto);

        assertNotNull(result);
        assertEquals("Campo Atualizado", result.getCampoTitulo());
        assertEquals(TipoCampo.DATA, result.getCampoTipo());
        verify(repositoryCampo, times(1)).findById("campoId1");
        verify(repositoryCampo, times(1)).save(campo);
    }

    @Test
    void alterarCampo_shouldThrowException_whenCampoNotFound() {
        CampoDTO updatedDto = mock(CampoDTO.class);
        when(updatedDto.getCampoTituloDto()).thenReturn("Campo Atualizado");
        when(updatedDto.getCampoTipoDto()).thenReturn(TipoCampo.DATA);

        when(repositoryCampo.findById("nonExistentCampoId")).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceCampo.alterarCampo("nonExistentCampoId", updatedDto);
        });
        verify(repositoryCampo, times(1)).findById("nonExistentCampoId");
        verify(repositoryCampo, never()).save(any(EntityCampo.class));
    }

    @Test
    void listarCamposByFormularioId_DeveRetornarCampos_QuandoFormularioExiste() {
        String formId = "formId1";
        List<EntityCampo> campos = List.of(
                new EntityCampo("Campo 1", TipoCampo.TEXTO, null),
                new EntityCampo("Campo 2", TipoCampo.NUMERO, null)
        );

        when(repositoryCampo.findAllBycampoFormId(formId)).thenReturn(Optional.of(campos));

        List<EntityCampo> resultado = serviceCampo.listarCamposByFormularioId(formId);

        assertNotNull(resultado);
        assertEquals(2, resultado.size());
        verify(repositoryCampo, times(1)).findAllBycampoFormId(formId);
    }

    @Test
    void listarCamposByFormularioId_DeveLancarExcecao_QuandoSemCampos() {
        String formId = "formIdInexistente";
        when(repositoryCampo.findAllBycampoFormId(formId)).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceCampo.listarCamposByFormularioId(formId);
        });

        verify(repositoryCampo, times(1)).findAllBycampoFormId(formId);
    }
}

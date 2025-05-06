package com.api.DataClick.services;


import com.api.DataClick.entities.EntityCampo;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.enums.TipoCampo;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryCampo;
import com.api.DataClick.repositories.RepositoryFormulario;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@SpringBootTest
public class ServiceCampoTest {

    @InjectMocks
    private ServiceCampo serviceCampo;

    @Mock
    private RepositoryCampo repositoryCampo;

    @Mock
    private RepositoryFormulario repositoryFormulario;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void listarCamposByFormularioId_existente_deveRetornarCampos() {
        String formId = "form1";
        List<EntityCampo> campos = Collections.singletonList(
                new EntityCampo("Email", TipoCampo.EMAIL)
        );

        when(repositoryCampo.findAllByformId(formId)).thenReturn(Optional.of(campos));

        List<EntityCampo> resultado = serviceCampo.listarCamposByFormularioId(formId);

        assertEquals(1, resultado.size());
        assertEquals("Email", resultado.get(0).getTitulo());
    }

    @Test
    void listarCamposByFormularioId_inexistente_deveLancarExcecao() {
        String formId = "inexistente";

        when(repositoryCampo.findAllByformId(formId)).thenReturn(Optional.empty());

        ExeptionNaoEncontrado ex = assertThrows(
                ExeptionNaoEncontrado.class,
                () -> serviceCampo.listarCamposByFormularioId(formId)
        );

        assertEquals(ExeceptionsMensage.CAMPO_NAO_ENCONTRADO, ex.getMessage());
    }

    @Test
    void adicionarCampo_deveSalvarCampoEAtualizarFormulario() {
        String formId = "form123";
        EntityFormulario formulario = new EntityFormulario("admin1", "Form teste");

        EntityCampo campo = new EntityCampo("Nome", TipoCampo.TEXTO);

        when(repositoryFormulario.findById(formId)).thenReturn(Optional.of(formulario));
        when(repositoryCampo.save(campo)).thenReturn(campo);
        when(repositoryFormulario.save(formulario)).thenReturn(formulario);

        EntityCampo resultado = serviceCampo.adicionarCampo(campo, formId);

        assertEquals("Nome", resultado.getTitulo());
        assertEquals(formId, resultado.getFormId());
        assertTrue(formulario.getCampos().contains(campo));
    }

    @Test
    void adicionarCampo_comFormularioInexistente_deveLancarExcecao() {
        String formId = "formInexistente";
        EntityCampo campo = new EntityCampo("Campo Teste", TipoCampo.TEXTO);

        when(repositoryFormulario.findById(formId)).thenReturn(Optional.empty());

        ExeptionNaoEncontrado ex = assertThrows(
                ExeptionNaoEncontrado.class,
                () -> serviceCampo.adicionarCampo(campo, formId)
        );

        assertEquals(ExeceptionsMensage.FORM_NAO_ENCONTRADO, ex.getMessage());
    }

    @Test
    void removerCampo_existente_deveRemoverCampo() {
        String campoId = "campo1";
        EntityCampo campo = new EntityCampo("Campo A", TipoCampo.TEXTO);

        when(repositoryCampo.findById(campoId)).thenReturn(Optional.of(campo));

        serviceCampo.removerCampo(campoId);

        verify(repositoryCampo).delete(campo);
    }

    @Test
    void removerCampo_inexistente_deveLancarExcecao() {
        String campoId = "inexistente";

        when(repositoryCampo.findById(campoId)).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> serviceCampo.removerCampo(campoId));
    }

    @Test
    void buscarCampoById_existente_deveRetornarCampo() {
        String campoId = "campo1";
        EntityCampo campo = new EntityCampo("Campo X", TipoCampo.DATA);

        when(repositoryCampo.findById(campoId)).thenReturn(Optional.of(campo));

        EntityCampo resultado = serviceCampo.buscarCampoById(campoId);

        assertEquals("Campo X", resultado.getTitulo());
    }

    @Test
    void buscarCampoById_inexistente_deveLancarExcecao() {
        String campoId = "naoExiste";

        when(repositoryCampo.findById(campoId)).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> serviceCampo.buscarCampoById(campoId));
    }

    @Test
    void alterarCampo_deveAtualizarTituloETipo() {
        String campoId = "campo123";
        EntityCampo campo = new EntityCampo("Antigo", TipoCampo.CHECKBOX);

        when(repositoryCampo.findById(campoId)).thenReturn(Optional.of(campo));
        when(repositoryCampo.save(any(EntityCampo.class))).thenAnswer(invocation -> invocation.getArgument(0));

        EntityCampo resultado = serviceCampo.alterarCampo(campoId, "TEXTO", "Novo Título");

        assertEquals("Novo Título", resultado.getTitulo());
        assertEquals(TipoCampo.TEXTO, resultado.getTipo());
    }

    @Test
    void alterarCampo_inexistente_deveLancarExcecao() {
        String campoId = "campoNaoExiste";

        when(repositoryCampo.findById(campoId)).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> serviceCampo.alterarCampo(campoId, "EMAIL", "Novo Email"));
    }
}

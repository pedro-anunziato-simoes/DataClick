package com.api.DataClick.services;

import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryFormulario;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@SpringBootTest
public class ServiceFormularioTest {
    @InjectMocks
    private ServiceFormulario serviceFormulario;

    @Mock
    private RepositoryFormulario repositoryFormulario;

    @Mock
    private RepositoryAdministrador repositoryAdministrador;

    @Mock
    private RepositoryRecrutador repositoryRecrutador;

    private EntityAdministrador admin;
    private EntityFormulario formulario;
    private EntityRecrutador recrutador;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        formulario = new EntityFormulario("admin-id", "Formulário Teste");
        admin = new EntityAdministrador("123456789", "Admin", "senha", "telefone", "admin@email.com", null);
        recrutador = new EntityRecrutador("Recrutador", "senha", "telefone", "recrutador@email.com", "admin-id", new ArrayList<>(), null);
        admin.setFormularios(new ArrayList<>());
        admin.setRecrutadores(List.of(recrutador));
    }


    @Test
    void criarFormulario_AdminNaoEncontrado_DeveLancarExcecao() {
        when(repositoryAdministrador.findById("admin-id")).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class,
                () -> serviceFormulario.criarFormulario(formulario, "admin-id"));
    }


    @Test
    void removerFormulario_DeveRemoverComSucesso() {
        admin.setFormularios(new ArrayList<>(List.of(formulario)));

        when(repositoryFormulario.findById("form-id")).thenReturn(Optional.of(formulario));
        when(repositoryAdministrador.findById("admin-id")).thenReturn(Optional.of(admin));

        formulario.setAdminId("admin-id");

        serviceFormulario.removerFormulario("form-id");

        verify(repositoryFormulario).delete(formulario);
        verify(repositoryAdministrador).save(admin);
        assertFalse(admin.getFormularios().contains(formulario));
    }

    @Test
    void bucarFormPorId_DeveRetornarFormulario() {
        when(repositoryFormulario.findById("form-id")).thenReturn(Optional.of(formulario));

        EntityFormulario resultado = serviceFormulario.bucarFormPorId("form-id");

        assertEquals("Formulário Teste", resultado.getTitulo());
    }

    @Test
    void bucarFormPorId_FormularioNaoEncontrado_DeveLancarExcecao() {
        when(repositoryFormulario.findById("form-id")).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> serviceFormulario.bucarFormPorId("form-id"));
    }

    @Test
    void buscarFormPorAdminId_DeveRetornarListaDeFormularios() {
        admin.setFormularios(List.of(formulario));

        when(repositoryAdministrador.findById("admin-id")).thenReturn(Optional.of(admin));

        List<EntityFormulario> resultado = serviceFormulario.buscarFormPorAdminId("admin-id");

        assertEquals(1, resultado.size());
        assertEquals("Formulário Teste", resultado.get(0).getTitulo());
    }

    @Test
    void buscarFormPorAdminId_AdminNaoEncontrado_DeveLancarExcecao() {
        when(repositoryAdministrador.findById("admin-id")).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> serviceFormulario.buscarFormPorAdminId("admin-id"));
    }
}

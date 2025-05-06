package com.api.DataClick.controllers;

import com.api.DataClick.DTO.FormularioUpdateDTO;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.Usuario;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.services.ServiceFormulario;
import com.api.DataClick.services.ServiceRecrutador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class ControllerFormularioTest {
    @Mock
    private ServiceFormulario serviceFormulario;

    @Mock
    private ServiceRecrutador serviceRecrutador;

    @InjectMocks
    private ControllerFormulario controllerFormulario;

    private Usuario adminUser;
    private Usuario regularUser;
    private Usuario recrutadorUser;
    private EntityFormulario formulario;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        adminUser = new Usuario() {{
            setUsuarioId("admin123");
            setRole(UserRole.ADMIN);
        }};

        regularUser = new Usuario() {{
            setUsuarioId("user456");
            setRole(UserRole.USER);
        }};

        recrutadorUser = new Usuario() {{
            setUsuarioId("rec789");
            setRole(UserRole.USER);
        }};

        formulario = new EntityFormulario("admin123", "Formulário Teste");
    }

    @Test
    void alterarFormulario_deveRetornarForbiddenParaNaoAdmin() {
        FormularioUpdateDTO dto = new FormularioUpdateDTO("Novo Título");
        ResponseEntity<EntityFormulario> response =
                controllerFormulario.alterarFormulario(dto, "form123", regularUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceFormulario, never()).alterarFormulario(any(), any());
    }

    @Test
    void alterarFormulario_deveAlterarQuandoAdmin() {
        when(serviceFormulario.bucarFormPorId("form123")).thenReturn(formulario);

        FormularioUpdateDTO dto = new FormularioUpdateDTO("Novo Título");
        ResponseEntity<EntityFormulario> response =
                controllerFormulario.alterarFormulario(dto, "form123", adminUser);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        verify(serviceFormulario).alterarFormulario(dto, "form123");
    }

    @Test
    void criarFormulario_deveRetornarForbiddenParaNaoAdmin() {
        EntityFormulario form = new EntityFormulario("admin123", "Novo Formulário");
        ResponseEntity<EntityFormulario> response =
                controllerFormulario.criarFormulario(form, regularUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceFormulario, never()).criarFormulario(any(), any());
    }

    @Test
    void criarFormulario_deveCriarQuandoAdmin() {
        EntityFormulario form = new EntityFormulario("admin123", "Novo Formulário");
        when(serviceFormulario.criarFormulario(form, "admin123")).thenReturn(form);

        ResponseEntity<EntityFormulario> response =
                controllerFormulario.criarFormulario(form, adminUser);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        verify(serviceFormulario).criarFormulario(form, "admin123");
    }

    @Test
    void removerFormulario_deveRetornarForbiddenParaNaoAdmin() {
        ResponseEntity<EntityFormulario> response =
                controllerFormulario.removerFormulario("form123", regularUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceFormulario, never()).removerFormulario(any());
    }

    @Test
    void removerFormulario_deveRemoverQuandoAdmin() {
        ResponseEntity<EntityFormulario> response =
                controllerFormulario.removerFormulario("form123", adminUser);

        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
        verify(serviceFormulario).removerFormulario("form123");
    }

    @Test
    void buscarForm_deveRetornarForbiddenParaUsuarioSemPermissao() {
        Usuario invalidUser = new Usuario() {{ setRole(UserRole.INVALID); }};

        ResponseEntity<EntityFormulario> response =
                controllerFormulario.buscarForm("form123", invalidUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
    }

    @Test
    void buscarForm_deveRetornarNotFoundQuandoFormNaoExiste() {
        when(serviceFormulario.bucarFormPorId("form999")).thenReturn(null);

        ResponseEntity<EntityFormulario> response =
                controllerFormulario.buscarForm("form999", recrutadorUser);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    void buscarForm_deveRetornarFormQuandoEncontrado() {
        when(serviceFormulario.bucarFormPorId("form123")).thenReturn(formulario);

        ResponseEntity<EntityFormulario> response =
                controllerFormulario.buscarForm("form123", recrutadorUser);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(formulario, response.getBody());
    }

    @Test
    void buscarFormByAdminId_deveRetornarForbiddenParaUsuarioSemPermissao() {
        Usuario invalidUser = new Usuario() {{ setRole(UserRole.INVALID); }};

        ResponseEntity<List<EntityFormulario>> response =
                controllerFormulario.buscarFormByAdminId(invalidUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
    }

    @Test
    void buscarFormByAdminId_deveUsarAdminIdQuandoUsuarioEhAdmin() {
        when(serviceFormulario.buscarFormPorAdminId("admin123"))
                .thenReturn(Collections.singletonList(formulario));

        ResponseEntity<List<EntityFormulario>> response =
                controllerFormulario.buscarFormByAdminId(adminUser);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        verify(serviceFormulario).buscarFormPorAdminId("admin123");
    }

    @Test
    void buscarFormByAdminId_deveBuscarAdminIdDoRecrutadorQuandoUsuarioEhUser() {
        when(serviceRecrutador.buscarAdminIdPorRecrutadorId("rec789"))
                .thenReturn(Optional.of("admin123"));
        when(serviceFormulario.buscarFormPorAdminId("admin123"))
                .thenReturn(Collections.singletonList(formulario));

        ResponseEntity<List<EntityFormulario>> response =
                controllerFormulario.buscarFormByAdminId(recrutadorUser);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        verify(serviceFormulario).buscarFormPorAdminId("admin123");
    }

    @Test
    void buscarFormByAdminId_deveRetornarNotFoundParaListaVazia() {
        when(serviceFormulario.buscarFormPorAdminId("admin123"))
                .thenReturn(Collections.emptyList());

        ResponseEntity<List<EntityFormulario>> response =
                controllerFormulario.buscarFormByAdminId(adminUser);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }
}

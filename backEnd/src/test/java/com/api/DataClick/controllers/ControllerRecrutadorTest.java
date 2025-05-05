package com.api.DataClick.controllers;

import com.api.DataClick.DTO.RecrutadorUpdateDTO;
import com.api.DataClick.DTO.RegisterRecrutadorDTO;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.entities.Usuario;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.services.ServiceRecrutador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class ControllerRecrutadorTest {
    @Mock
    private ServiceRecrutador serviceRecrutador;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private ControllerRecrutador controllerRecrutador;

    private Usuario adminUser;
    private Usuario regularUser;
    private EntityRecrutador recrutador;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        adminUser = new EntityAdministrador(
                "19232630000110",
                "teste",
                "senha",
                "44999999999",
                "admin@test.com",
                UserRole.ADMIN
        );
        adminUser.setUsuarioId("admin123");

        regularUser = new EntityRecrutador(
                "Regular User",
                "senha",
                "44888888888",
                "regular@test.com",
                "admin123",
                Collections.emptyList(),
                UserRole.USER
        );
        regularUser.setUsuarioId("2");

        recrutador = new EntityRecrutador(
                "Recrutador Teste",
                "senha",
                "44999988888",
                "rec@test.com",
                "admin123",
                Collections.emptyList(),
                UserRole.USER
        );
        recrutador.setUsuarioId("1");
    }

    @Test
    void removerRecrutador_deveRetornarForbiddenParaNaoAdmin() {
        ResponseEntity<Void> response = controllerRecrutador.removerRecrutador("1", regularUser);
        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
    }

    @Test
    void removerRecrutador_deveRemoverQuandoAdmin() {
        ResponseEntity<Void> response = controllerRecrutador.removerRecrutador("1", adminUser);
        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
        verify(serviceRecrutador).removerRecrutador("1");
    }

    @Test
    void listarRecrutadores_deveRetornarForbiddenParaNaoAdmin() {
        ResponseEntity<List<EntityRecrutador>> response =
                controllerRecrutador.listarRecrutadores(regularUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceRecrutador, never()).listarRecrutadores(anyString());
    }

    @Test
    void listarRecrutadores_deveRetornarListaQuandoAdmin() {

        when(serviceRecrutador.listarRecrutadores(eq("admin123")))
                .thenReturn(List.of(recrutador));

        ResponseEntity<List<EntityRecrutador>> response =
                controllerRecrutador.listarRecrutadores(adminUser);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertFalse(response.getBody().isEmpty());
        verify(serviceRecrutador).listarRecrutadores("admin123");
    }
    @Test
    void buscarRecrut_deveRetornarRecrutadorQuandoEncontrado() {
        when(serviceRecrutador.buscarRecrut("1")).thenReturn(recrutador);

        ResponseEntity<EntityRecrutador> response =
                controllerRecrutador.buscarRecrut("1", adminUser);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("Recrutador Teste", response.getBody().getNome());
    }

    @Test
    void buscarRecrut_deveRetornarForbiddenParaNaoAdmin() {
        ResponseEntity<EntityRecrutador> response =
                controllerRecrutador.buscarRecrut("1", regularUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceRecrutador, never()).buscarRecrut(anyString());
    }

    @Test
    void criarRecrutador_deveRetornarForbiddenParaNaoAdmin() {
        RegisterRecrutadorDTO dto = new RegisterRecrutadorDTO(
                "Novo", "novo@test.com", "senha", "44999999999"
        );

        ResponseEntity<EntityRecrutador> response =
                controllerRecrutador.criarRecrutador(dto, regularUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceRecrutador, never()).criarRecrutador(any());
    }
    @Test
    void criarRecrutador_deveCriarComSenhaCriptografada() {
        RegisterRecrutadorDTO dto = new RegisterRecrutadorDTO(
                "Novo", "novo@test.com", "senha", "44999999999"
        );

        when(passwordEncoder.encode("senha")).thenReturn("telefoneHash");
        when(serviceRecrutador.criarRecrutador(any())).thenReturn(recrutador);

        ResponseEntity<EntityRecrutador> response =
                controllerRecrutador.criarRecrutador(dto, adminUser);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        verify(passwordEncoder).encode("senha");
    }

    @Test
    void alterarRecrutador_deveAtualizarCamposCorretamente() {
        RecrutadorUpdateDTO dto = new RecrutadorUpdateDTO(
                "Novo Nome",
                "44999999999",
                "novo@email.com"
        );

        EntityRecrutador recrutadorAtualizado = new EntityRecrutador(
                dto.getNome(),
                "senha",
                dto.getTelefone(),
                dto.getEmail(),
                "admin123",
                Collections.emptyList(),
                UserRole.USER
        );
        recrutadorAtualizado.setUsuarioId("1");

        when(serviceRecrutador.alterarRecrutador("1", dto))
                .thenReturn(recrutadorAtualizado);

        ResponseEntity<EntityRecrutador> response =
                controllerRecrutador.alterarRecrutador("1", dto, adminUser);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("Novo Nome", response.getBody().getNome());
        assertEquals("novo@email.com", response.getBody().getEmail());
    }

    @Test
    void infoAdm_deveChamarServicoCorretamente() {
        when(serviceRecrutador.infoRec(anyString())).thenReturn(recrutador);

        ResponseEntity<EntityAdministrador> response =
                controllerRecrutador.infoAdm(adminUser);

        verify(serviceRecrutador).infoRec(adminUser.getUsuarioId());
        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
    }

    @Test
    void alterarEmail_deveAtualizarEmail() {
        controllerRecrutador.alterarEmail(adminUser, "novo@email.com");
        verify(serviceRecrutador).alterarEmail("novo@email.com", adminUser.getUsuarioId());
    }

    @Test
    void alterarSenha_deveAtualizarSenha() {
        controllerRecrutador.alterarSenha(adminUser, "novaSenha");
        verify(serviceRecrutador).alterarSenha("novaSenha", adminUser.getUsuarioId());
    }

    @Test
    void alterarRecrutador_deveRetornarForbiddenParaNaoAdmin() {
        RecrutadorUpdateDTO dto = new RecrutadorUpdateDTO(
                "Novo Nome", "44999999999", "novo@email.com"
        );

        ResponseEntity<EntityRecrutador> response =
                controllerRecrutador.alterarRecrutador("1", dto, regularUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceRecrutador, never()).alterarRecrutador(anyString(), any());
    }

    @Test
    void infoAdm_deveRetornarForbiddenParaNaoAdmin() {
        ResponseEntity<EntityAdministrador> response =
                controllerRecrutador.infoAdm(regularUser);

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        verify(serviceRecrutador, never()).infoRec(anyString());
    }
    @Test
    void alterarEmail_deveRetornarForbiddenParaNaoAdmin() {
        controllerRecrutador.alterarEmail(regularUser, "novo@email.com");
        verify(serviceRecrutador, never()).alterarEmail(anyString(), anyString());
    }
    @Test
    void alterarSenha_deveRetornarForbiddenParaNaoAdmin() {
        controllerRecrutador.alterarSenha(regularUser, "novaSenha");
        verify(serviceRecrutador, never()).alterarSenha(anyString(), anyString());
    }

    @Test
    void listarRecrutadores_deveRetornarNotFoundParaListaVazia() {
        when(serviceRecrutador.listarRecrutadores(anyString()))
                .thenReturn(Collections.emptyList());

        ResponseEntity<List<EntityRecrutador>> response =
                controllerRecrutador.listarRecrutadores(adminUser);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    void buscarRecrut_deveRetornarNotFoundParaIdInvalido() {
        when(serviceRecrutador.buscarRecrut("999")).thenReturn(null);

        ResponseEntity<EntityRecrutador> response =
                controllerRecrutador.buscarRecrut("999", adminUser);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }
}

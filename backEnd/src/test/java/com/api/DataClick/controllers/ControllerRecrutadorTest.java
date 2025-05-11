package com.api.DataClick.controllers;

import com.api.DataClick.DTO.RecrutadorDTO;
import com.api.DataClick.DTO.RegisterRecrutadorDTO;
import com.api.DataClick.entities.*;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.services.ServiceEvento;
import com.api.DataClick.services.ServiceRecrutador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Collections;
import java.util.Date;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;
@ExtendWith(MockitoExtension.class)
public class ControllerRecrutadorTest {

    @Mock
    private ServiceRecrutador serviceRecrutador;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private ControllerRecrutador controller;

    @Mock
    private ServiceEvento serviceEvento;

    private EntityAdministrador admin;
    private EntityRecrutador invalido;
    private EntityRecrutador recrutador;
    private RegisterRecrutadorDTO registerDTO;
    private RecrutadorDTO recrutadorDTO;

    @BeforeEach
    void setUp() {

        registerDTO = new RegisterRecrutadorDTO(
                "Novo Recrutador",
                "senha123",
                "11999996666",
                "novo@test.com"
        );


        admin = new EntityAdministrador(
                "123456789",
                "Admin Teste",
                "senha123",
                "11999998888",
                "admin@test.com",
                UserRole.ADMIN
        );
        admin.setUsuarioId("adm-001");


        invalido = new EntityRecrutador(
                "Recrutador Teste",
                "senha123",
                "11999997777",
                "user@test.com",
                "adm-001",
                UserRole.INVALID,
                Collections.emptyList()
        );
        invalido.setUsuarioId("user-001");

        recrutador = new EntityRecrutador(
                "Recrutador Teste",
                "senha123",
                "11999997777",
                "recrutador@test.com",
                "adm-001",
                UserRole.USER,
                Collections.emptyList()
        );
        recrutador.setUsuarioId("rec-001");

        registerDTO = new RegisterRecrutadorDTO(
                "Novo Recrutador",
                "senha123",
                "11999996666",
                "novo@test.com"
        );

        recrutadorDTO = new RecrutadorDTO();
        recrutadorDTO.setRecrutadorNomeDto("rec-teste");
        recrutadorDTO.setRecrutadorSenhaDto("teste");
        recrutadorDTO.setRecrutadoTelefoneDto("11999996666");
        recrutadorDTO.setRecrutadoEmailDto("novo@test.com");
        Date dataAtual = new Date();

        List<EntityEvento> eventosAdmin = List.of(
                new EntityEvento("adm-001", "TESTE", "Descricao", dataAtual, Collections.emptyList())
        );

        when(serviceEvento.listarEventosPorAdmin(anyString())).thenReturn(eventosAdmin);
    }

    @Test
    void removerRecrutador_Admin_DeveRetornarNoContent() {
        ResponseEntity<Void> response = controller.removerRecrutador("rec-001", admin);
        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
        verify(serviceRecrutador).removerRecrutador("rec-001");
    }

    @Test
    void removerRecrutador_NaoAdmin_DeveRetornarForbidden() {
        ResponseEntity<Void> response = controller.removerRecrutador("rec-001", invalido);
        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
    }

    @Test
    void listarRecrutadores_Admin_DeveRetornarLista() {
        when(serviceRecrutador.listarRecrutadores(anyString()))
                .thenReturn(List.of(recrutador));

        ResponseEntity<List<EntityRecrutador>> response = controller.listarRecrutadores(admin);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertFalse(response.getBody().isEmpty());
    }

    @Test
    void listarRecrutadores_NaoAdmin_DeveRetornarForbidden() {
        ResponseEntity<List<EntityRecrutador>> response = controller.listarRecrutadores(invalido);
        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
    }

    @Test
    void buscarRecrut_Admin_DeveRetornarRecrutador() {
        when(serviceRecrutador.buscarRecrut(anyString())).thenReturn(recrutador);

        ResponseEntity<EntityRecrutador> response = controller.buscarRecrut("rec-001", admin);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(recrutador, response.getBody());
    }

    @Test
    void buscarRecrut_NaoEncontrado_DeveRetornarNotFound() {
        when(serviceRecrutador.buscarRecrut(anyString())).thenReturn(null);

        ResponseEntity<EntityRecrutador> response = controller.buscarRecrut("rec-001", admin);
        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }


    @Test
    void alterarRecrutador_Admin_DeveRetornarAtualizado() {
        when(serviceRecrutador.alterarRecrutador(anyString(), any())).thenReturn(recrutador);

        ResponseEntity<EntityRecrutador> response = controller.alterarRecrutador("rec-001", recrutadorDTO, admin);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        verify(serviceRecrutador).alterarRecrutador("rec-001", recrutadorDTO);
    }

    @Test
    void infoAdm_Admin_DeveRetornarInformacoes() {
        when(serviceRecrutador.infoRec(anyString())).thenReturn(recrutador);

        ResponseEntity<EntityRecrutador> response = controller.infoAdm(admin);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(recrutador, response.getBody());
    }

    @Test
    void alterarEmail_Admin_DeveAtualizarEmail() {
        ResponseEntity<Void> response = controller.alterarEmail(admin, "novo@test.com");
        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
        verify(serviceRecrutador).alterarEmail("novo@test.com", admin.getUsuarioId());
    }

    @Test
    void alterarSenha_Admin_DeveAtualizarSenha() {
        ResponseEntity<Void> response = controller.alterarSenha(admin, "novaSenha");
        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
        verify(serviceRecrutador).alterarSenha("novaSenha", admin.getUsuarioId());
    }
    @Test
    void criarRecrutador_Admin_DeveRetornarRecrutadorCriadoComStatusCreated() {

        Date dataAtual = new Date();

        List<EntityEvento> eventosAdmin = List.of(
                new EntityEvento("adm-001", "TESTE", "Descricao", dataAtual, Collections.emptyList())
        );
        when(serviceEvento.listarEventosPorAdmin(admin.getUsuarioId())).thenReturn(eventosAdmin);

        when(passwordEncoder.encode(registerDTO.senha())).thenReturn("senhaCriptografada");

        EntityRecrutador recrutadorEsperado = new EntityRecrutador(
                registerDTO.nome(),
                "senhaCriptografada",
                registerDTO.telefone(),
                registerDTO.email(),
                admin.getUsuarioId(),
                UserRole.USER,
                eventosAdmin
        );
        recrutadorEsperado.setUsuarioId("rec-002");
        when(serviceRecrutador.criarRecrutador(any(EntityRecrutador.class))).thenReturn(recrutadorEsperado);

        ResponseEntity<EntityRecrutador> resposta = controller.criarRecrutador(registerDTO, admin);

        assertEquals(HttpStatus.CREATED, resposta.getStatusCode());
        assertSame(recrutadorEsperado, resposta.getBody());

        verify(serviceEvento).listarEventosPorAdmin(admin.getUsuarioId());
        verify(passwordEncoder).encode(registerDTO.senha());

        ArgumentCaptor<EntityRecrutador> captor = ArgumentCaptor.forClass(EntityRecrutador.class);
        verify(serviceRecrutador).criarRecrutador(captor.capture());

        EntityRecrutador recrutadorCriado = captor.getValue();
        assertAll(
                () -> assertEquals(registerDTO.nome(), recrutadorCriado.getNome()),
                () -> assertEquals("senhaCriptografada", recrutadorCriado.getSenha()),
                () -> assertEquals(admin.getUsuarioId(), recrutadorCriado.getAdminId()),
                () -> assertEquals(UserRole.USER, recrutadorCriado.getRole()),
                () -> assertEquals(eventosAdmin, recrutadorCriado.getEventos())
        );
    }

    @Test
    void todosEndpoints_NaoAdmin_DeveRetornarForbidden() {
        ResponseEntity<Void> removeResponse = controller.removerRecrutador("rec-001", invalido);
        ResponseEntity<List<EntityRecrutador>> listResponse = controller.listarRecrutadores(invalido);
        ResponseEntity<EntityRecrutador> buscarResponse = controller.buscarRecrut("rec-001", invalido);
        ResponseEntity<EntityRecrutador> criarResponse = controller.criarRecrutador(registerDTO, invalido);
        ResponseEntity<EntityRecrutador> alterarResponse = controller.alterarRecrutador("rec-001", recrutadorDTO, invalido);
        ResponseEntity<EntityRecrutador> infoResponse = controller.infoAdm(invalido);
        ResponseEntity<Void> emailResponse = controller.alterarEmail(invalido, "novo@test.com");
        ResponseEntity<Void> senhaResponse = controller.alterarSenha(invalido, "novaSenha");

        assertAll(
                () -> assertEquals(HttpStatus.FORBIDDEN, removeResponse.getStatusCode()),
                () -> assertEquals(HttpStatus.FORBIDDEN, listResponse.getStatusCode()),
                () -> assertEquals(HttpStatus.FORBIDDEN, buscarResponse.getStatusCode()),
                () -> assertEquals(HttpStatus.FORBIDDEN, criarResponse.getStatusCode()),
                () -> assertEquals(HttpStatus.FORBIDDEN, alterarResponse.getStatusCode()),
                () -> assertEquals(HttpStatus.FORBIDDEN, infoResponse.getStatusCode()),
                () -> assertEquals(HttpStatus.FORBIDDEN, emailResponse.getStatusCode()),
                () -> assertEquals(HttpStatus.FORBIDDEN, senhaResponse.getStatusCode())
        );
    }
}

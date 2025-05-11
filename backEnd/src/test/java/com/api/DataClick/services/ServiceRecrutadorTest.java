package com.api.DataClick.services;

import com.api.DataClick.DTO.RecrutadorDTO;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

public class ServiceRecrutadorTest {

    @Mock
    private RepositoryRecrutador repositoryRecrutador;

    @Mock
    private RepositoryAdministrador repositoryAdministrador;

    @InjectMocks
    private ServiceRecrutador serviceRecrutador;

    private EntityRecrutador recrutador;
    private EntityAdministrador administrador;
    private final String recId = "rec-001";
    private final String adminId = "aadm-001";

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        administrador = new EntityAdministrador(
                "123456789",
                "Admin Teste",
                "senha123",
                "11999998888",
                "admin@test.com",
                UserRole.ADMIN
        );
        administrador.setUsuarioId("adm-001");

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
    }

    @Test
    void criarRecrutador_DeveSalvarERelacionarComAdmin() {
        when(repositoryRecrutador.save(any())).thenReturn(recrutador);
        when(repositoryAdministrador.findById("adm-001")).thenReturn(Optional.of(administrador));
        when(repositoryAdministrador.save(any())).thenReturn(administrador);

        EntityRecrutador resultado = serviceRecrutador.criarRecrutador(recrutador);

        assertNotNull(resultado);
        verify(repositoryRecrutador).save(recrutador);
        verify(repositoryAdministrador).save(administrador);
        assertTrue(administrador.getAdminRecrutadores().contains(recrutador));
    }

    @Test
    void removerRecrutador_DeveChamarDelete() {
        serviceRecrutador.removerRecrutador(recId);
        verify(repositoryRecrutador).deleteById(recId);
    }

    @Test
    void listarRecrutadores_DeveRetornarListaQuandoAdminExiste() {
        administrador.getAdminRecrutadores().add(recrutador);
        when(repositoryAdministrador.findById(adminId)).thenReturn(Optional.of(administrador));

        List<EntityRecrutador> resultado = serviceRecrutador.listarRecrutadores(adminId);

        assertFalse(resultado.isEmpty());
        assertEquals(1, resultado.size());
    }

    @Test
    void listarRecrutadores_DeveLancarExcecaoQuandoAdminNaoExiste() {
        when(repositoryAdministrador.findById(adminId)).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () ->
                serviceRecrutador.listarRecrutadores(adminId));
    }

    @Test
    void buscarRecrut_DeveRetornarRecrutadorQuandoExiste() {
        when(repositoryRecrutador.findById(recId)).thenReturn(Optional.of(recrutador));

        EntityRecrutador resultado = serviceRecrutador.buscarRecrut(recId);

        assertNotNull(resultado);
        assertEquals("rec-001", resultado.getUsuarioId());
    }

    @Test
    void buscarRecrut_DeveLancarExcecaoQuandoNaoExiste() {
        when(repositoryRecrutador.findById(recId)).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () ->
                serviceRecrutador.buscarRecrut(recId));
    }

    @Test
    void alterarRecrutador_DeveAtualizarCampos() {
        RecrutadorDTO dto = new RecrutadorDTO();
        dto.setRecrutadoEmailDto("novo@email.com");
        dto.setRecrutadoTelefoneDto("999999999");
        dto.setRecrutadorNomeDto("Novo Nome");

        when(repositoryRecrutador.findById(recId)).thenReturn(Optional.of(recrutador));
        when(repositoryRecrutador.save(any())).thenReturn(recrutador);

        EntityRecrutador resultado = serviceRecrutador.alterarRecrutador(recId, dto);

        assertEquals(dto.getRecrutadoEmailDto(), resultado.getEmail());
        assertEquals(dto.getRecrutadoTelefoneDto(), resultado.getTelefone());
        assertEquals(dto.getRecrutadorNomeDto(), resultado.getNome());
    }

    @Test
    void buscarAdminIdPorRecrutadorId_DeveRetornarAdminId() {
        when(repositoryRecrutador.findById(recId)).thenReturn(Optional.of(recrutador));

        Optional<String> resultado = serviceRecrutador.buscarAdminIdPorRecrutadorId(recId);

        assertTrue(resultado.isPresent());
        assertEquals("adm-001", resultado.get());
    }

    @Test
    void alterarEmail_DeveAtualizarEmail() {
        String novoEmail = "novo@email.com";
        when(repositoryRecrutador.findById(recId)).thenReturn(Optional.of(recrutador));

        serviceRecrutador.alterarEmail(novoEmail, recId);

        assertEquals(novoEmail, recrutador.getEmail());
        verify(repositoryRecrutador).save(recrutador);
    }

    @Test
    void alterarSenha_DeveAtualizarSenha() {
        String novaSenha = "novaSenha123";
        when(repositoryRecrutador.findById(recId)).thenReturn(Optional.of(recrutador));

        serviceRecrutador.alterarSenha(novaSenha, recId);

        assertEquals(novaSenha, recrutador.getSenha());
        verify(repositoryRecrutador).save(recrutador);
    }

    @Test
    void infoRec_DeveRetornarRecrutador() {
        when(repositoryRecrutador.findById(recId)).thenReturn(Optional.of(recrutador));

        EntityRecrutador resultado = serviceRecrutador.infoRec(recId);

        assertNotNull(resultado);
        assertEquals("rec-001", resultado.getUsuarioId());
    }
}

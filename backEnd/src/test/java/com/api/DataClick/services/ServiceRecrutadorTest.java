package com.api.DataClick.services;

import com.api.DataClick.DTO.RecrutadorUpdateDTO;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@SpringBootTest
public class ServiceRecrutadorTest {

    @Mock
    private RepositoryRecrutador repositoryRecrutador;

    @Mock
    private RepositoryAdministrador repositoryAdministrador;

    @InjectMocks
    private ServiceRecrutador serviceRecrutador;

    private EntityRecrutador recrutador;
    private EntityAdministrador administrador;

    @BeforeEach
    void setUp() {
        administrador = new EntityAdministrador("cnpj123", "Administrador", "senha", "telefone", "admin@teste.com", UserRole.ADMIN);
        recrutador = new EntityRecrutador("recrutador1", "senha", "telefone", "email", "adminId123", null, null);
        recrutador.setUsuarioId("recrutadorId123");
    }

    @Test
    void testListarTodosRecrutadores() {
        when(repositoryRecrutador.findAll()).thenReturn(Arrays.asList(recrutador));

        List<EntityRecrutador> result = serviceRecrutador.listarTodosRecrutadores();

        assertNotNull(result);
        assertFalse(result.isEmpty());
        assertEquals(1, result.size());
        assertEquals("recrutadorId123", result.get(0).getUsuarioId());
    }

    @Test
    void testCriarRecrutador() {
        when(repositoryRecrutador.save(recrutador)).thenReturn(recrutador);
        when(repositoryAdministrador.findById("adminId123")).thenReturn(Optional.of(administrador));
        when(repositoryAdministrador.save(administrador)).thenReturn(administrador);

        EntityRecrutador result = serviceRecrutador.criarRecrutador(recrutador);

        verify(repositoryRecrutador, times(1)).save(recrutador);
        verify(repositoryAdministrador, times(1)).save(administrador);

        assertNotNull(result);
        assertEquals("recrutadorId123", result.getUsuarioId());
        assertTrue(administrador.getRecrutadores().contains(recrutador));
    }

    @Test
    void testCriarRecrutadorAdministradorNaoEncontrado() {
        when(repositoryRecrutador.save(recrutador)).thenReturn(recrutador);
        when(repositoryAdministrador.findById("adminId123")).thenReturn(Optional.empty());

        Exception exception = assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceRecrutador.criarRecrutador(recrutador);
        });

        assertEquals("Administrador não encontrado adminId123", exception.getMessage());
    }

    @Test
    void testRemoverRecrutador() {
        doNothing().when(repositoryRecrutador).deleteById("recrutadorId123");

        serviceRecrutador.removerRecrutador("recrutadorId123");

        verify(repositoryRecrutador, times(1)).deleteById("recrutadorId123");
    }

    @Test
    void testListarRecrutadores() {
        when(repositoryAdministrador.findById("adminId123")).thenReturn(Optional.of(administrador));

        List<EntityRecrutador> result = serviceRecrutador.listarRecrutadores("adminId123");

        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void testListarRecrutadoresAdministradorNaoEncontrado() {
        when(repositoryAdministrador.findById("adminId123")).thenReturn(Optional.empty());

        Exception exception = assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceRecrutador.listarRecrutadores("adminId123");
        });

        assertEquals(ExeceptionsMensage.ADM_NAO_ENCONTRADO, exception.getMessage());
    }

    @Test
    void testBuscarRecrutador() {
        when(repositoryRecrutador.findById("recrutadorId123")).thenReturn(Optional.of(recrutador));

        EntityRecrutador result = serviceRecrutador.buscarRecrut("recrutadorId123");

        assertNotNull(result);
        assertEquals("recrutadorId123", result.getUsuarioId());
    }

    @Test
    void testBuscarRecrutadorNaoEncontrado() {
        when(repositoryRecrutador.findById("recrutadorId123")).thenReturn(Optional.empty());

        Exception exception = assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceRecrutador.buscarRecrut("recrutadorId123");
        });

        assertEquals(ExeceptionsMensage.REC_NAO_ENCONTRADO, exception.getMessage());
    }

    @Test
    void testBuscarAdminIdPorRecrutadorId_Encontrado() {
        when(repositoryRecrutador.findById("recrutadorId123"))
                .thenReturn(Optional.of(recrutador));

        Optional<String> result = serviceRecrutador.buscarAdminIdPorRecrutadorId("recrutadorId123");

        assertTrue(result.isPresent());
        assertEquals("adminId123", result.get());
    }

    @Test
    void testBuscarAdminIdPorRecrutadorId_NaoEncontrado() {
        when(repositoryRecrutador.findById("recrutadorId123"))
                .thenReturn(Optional.empty());

        Optional<String> result = serviceRecrutador.buscarAdminIdPorRecrutadorId("recrutadorId123");

        assertTrue(result.isEmpty());
    }

    @Test
    void testAlterarRecrutador() {
        RecrutadorUpdateDTO dto = new RecrutadorUpdateDTO( "Novo Nome",
                "987654321",
                "novo@email.com");
        dto.setEmail("novo@email.com");
        dto.setTelefone("987654321");
        dto.setNome("Novo Nome");

        when(repositoryRecrutador.findById("recrutadorId123"))
                .thenReturn(Optional.of(recrutador));
        when(repositoryRecrutador.save(any(EntityRecrutador.class)))
                .thenReturn(recrutador);

        EntityRecrutador result = serviceRecrutador.alterarRecrutador("recrutadorId123", dto);

        assertNotNull(result);
        assertEquals("novo@email.com", result.getEmail());
        assertEquals("987654321", result.getTelefone());
        assertEquals("Novo Nome", result.getNome());
        verify(repositoryRecrutador).save(recrutador);
    }

    @Test
    void testAlterarRecrutador_NaoEncontrado() {
        RecrutadorUpdateDTO dto = new RecrutadorUpdateDTO(  "Nome",
                "telefone",
                "email");
        when(repositoryRecrutador.findById("recrutadorId123"))
                .thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceRecrutador.alterarRecrutador("recrutadorId123", dto);
        });
    }

    @Test
    void testInfoRec() {
        when(repositoryRecrutador.findById("recrutadorId123"))
                .thenReturn(Optional.of(recrutador));

        EntityRecrutador result = serviceRecrutador.infoRec("recrutadorId123");

        assertNotNull(result);
        assertEquals("recrutadorId123", result.getUsuarioId());
    }

    @Test
    void testInfoRec_NaoEncontrado() {
        when(repositoryRecrutador.findById("recrutadorId123"))
                .thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceRecrutador.infoRec("recrutadorId123");
        });
    }

    @Test
    void testAlterarEmail() {
        when(repositoryRecrutador.findById("recrutadorId123"))
                .thenReturn(Optional.of(recrutador));

        serviceRecrutador.alterarEmail("novo@email.com", "recrutadorId123");

        assertEquals("novo@email.com", recrutador.getEmail());
        verify(repositoryRecrutador).save(recrutador);
    }

    @Test
    void testAlterarEmail_NaoEncontrado() {
        when(repositoryRecrutador.findById("recrutadorId123"))
                .thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceRecrutador.alterarEmail("novo@email.com", "recrutadorId123");
        });
    }

    @Test
    void testAlterarSenha() {
        when(repositoryRecrutador.findById("recrutadorId123"))
                .thenReturn(Optional.of(recrutador));

        serviceRecrutador.alterarSenha("novaSenha", "recrutadorId123");

        assertEquals("novaSenha", recrutador.getSenha());
        verify(repositoryRecrutador).save(recrutador);
    }

    @Test
    void testAlterarSenha_NaoEncontrado() {
        when(repositoryRecrutador.findById("recrutadorId123"))
                .thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceRecrutador.alterarSenha("novaSenha", "recrutadorId123");
        });
    }
}

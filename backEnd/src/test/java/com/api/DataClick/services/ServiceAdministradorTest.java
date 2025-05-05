package com.api.DataClick.services;


import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@SpringBootTest
public class ServiceAdministradorTest {

    @Mock
    private RepositoryAdministrador repositoryAdministrador;

    @Mock
    private RepositoryRecrutador repositoryRecrutador;

    @InjectMocks
    private ServiceAdministrador serviceAdministrador;

    private EntityAdministrador administrador;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        administrador = new EntityAdministrador(
                "12345678000100",
                "João Admin",
                "senhaSegura",
                "44999999999",
                "joao@email.com",
                UserRole.ADMIN
        );
    }

    @Test
    void deveAdicionarAdministrador() {
        when(repositoryAdministrador.save(administrador)).thenReturn(administrador);

        EntityAdministrador resultado = serviceAdministrador.adicionarAdmin(administrador);

        assertNotNull(resultado);
        assertEquals("João Admin", resultado.getNome());
        verify(repositoryAdministrador, times(1)).save(administrador);
    }

    @Test
    void deveListarAdministradores() {
        when(repositoryAdministrador.findAll()).thenReturn(List.of(administrador));

        List<EntityAdministrador> resultado = serviceAdministrador.listarAdministradores();

        assertFalse(resultado.isEmpty());
        assertEquals(1, resultado.size());
        verify(repositoryAdministrador, times(1)).findAll();
    }

    @Test
    void deveRemoverAdministrador() {
        String adminId = "id123";

        serviceAdministrador.removerAdm(adminId);

        verify(repositoryAdministrador, times(1)).deleteById(adminId);
    }

    @Test
    void deveRetornarAuthoritiesCorretamente() {
        assertEquals(1, administrador.getAuthorities().size());
        assertEquals("ROLE_ADMIN", administrador.getAuthorities().iterator().next().getAuthority());
    }

    @Test
    void deveRetornarEmailComoUsername() {
        assertEquals("joao@email.com", administrador.getUsername());
    }

    @Test
    void deveRetornarSenhaCorretamente() {
        assertEquals("senhaSegura", administrador.getPassword());
    }

    @Test
    void deveEstarComContaAtiva() {
        assertTrue(administrador.isAccountNonLocked());
        assertTrue(administrador.isCredentialsNonExpired());
        assertTrue(administrador.isEnabled());
    }


    @Test
    void deveRetornarAdminPorId() {
        String admId = "123";
        when(repositoryAdministrador.findById(admId)).thenReturn(Optional.of(administrador));

        EntityAdministrador resultado = serviceAdministrador.infoAdm(admId);

        assertNotNull(resultado);
        assertEquals("João Admin", resultado.getNome());
        verify(repositoryAdministrador, times(1)).findById(admId);
    }

    @Test
    void deveLancarExcecaoAoBuscarAdminInexistente() {
        String admId = "999";
        when(repositoryAdministrador.findById(admId)).thenReturn(Optional.empty());

        ExeptionNaoEncontrado exception = assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceAdministrador.infoAdm(admId);
        });

        assertEquals(ExeceptionsMensage.ADM_NAO_ENCONTRADO, exception.getMessage());
        verify(repositoryAdministrador, times(1)).findById(admId);
    }

    @Test
    void deveAlterarEmailComSucesso() {
        String admId = "123";
        String novoEmail = "novo@email.com";
        when(repositoryAdministrador.findById(admId)).thenReturn(Optional.of(administrador));

        serviceAdministrador.alterarEmail(novoEmail, admId);

        assertEquals(novoEmail, administrador.getEmail());
        verify(repositoryAdministrador, times(1)).save(administrador);
    }

    @Test
    void deveLancarExcecaoAoAlterarEmailAdminInexistente() {
        String admId = "999";
        when(repositoryAdministrador.findById(admId)).thenReturn(Optional.empty());

        ExeptionNaoEncontrado exception = assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceAdministrador.alterarEmail("novo@email.com", admId);
        });

        assertEquals(ExeceptionsMensage.ADM_NAO_ENCONTRADO, exception.getMessage());
        verify(repositoryAdministrador, never()).save(any());
    }

    @Test
    void deveAlterarSenhaComSucesso() {
        String admId = "123";
        String novaSenha = "novaSenhaSegura";
        when(repositoryAdministrador.findById(admId)).thenReturn(Optional.of(administrador));

        serviceAdministrador.alterarSenha(novaSenha, admId);

        assertEquals(novaSenha, administrador.getSenha());
        verify(repositoryAdministrador, times(1)).save(administrador);
    }

    @Test
    void deveLancarExcecaoAoAlterarSenhaAdminInexistente() {
        String admId = "999";
        when(repositoryAdministrador.findById(admId)).thenReturn(Optional.empty());

        ExeptionNaoEncontrado exception = assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceAdministrador.alterarSenha("novaSenha", admId);
        });

        assertEquals(ExeceptionsMensage.ADM_NAO_ENCONTRADO, exception.getMessage());
        verify(repositoryAdministrador, never()).save(any());
    }
}


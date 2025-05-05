package com.api.DataClick.services;


import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.util.Collections;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@SpringBootTest
public class ServiceAuthorizationTest {

    @Mock
    private RepositoryAdministrador repositoryAdministrador;

    @Mock
    private RepositoryRecrutador repositoryRecrutador;

    @InjectMocks
    private ServiceAuthorization serviceAuthorization;

    private EntityAdministrador admin;
    private EntityRecrutador recrutador;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        admin = new EntityAdministrador(
                "12345678000100",
                "Admin Teste",
                "senhaAdmin",
                "44999999999",
                "admin@dataclick.com",
                UserRole.ADMIN
        );

        recrutador = new EntityRecrutador(
                "Recrutador Teste",
                "senhaRecrutador",
                "44999988888",
                "recrutador@dataclick.com",
                "adminId123",
                Collections.emptyList(),
                UserRole.USER
        );
    }

    @Test
    void deveRetornarAdminQuandoEncontradoPorEmail() {
        when(repositoryAdministrador.findByEmail("admin@dataclick.com")).thenReturn(admin);

        UserDetails user = serviceAuthorization.loadUserByUsername("admin@dataclick.com");

        assertNotNull(user);
        assertEquals("admin@dataclick.com", user.getUsername());
        verify(repositoryAdministrador, times(1)).findByEmail("admin@dataclick.com");
        verify(repositoryRecrutador, never()).findByEmail(anyString());
    }

    @Test
    void deveRetornarRecrutadorQuandoNaoForAdmin() {
        when(repositoryAdministrador.findByEmail("recrutador@dataclick.com")).thenReturn(null);
        when(repositoryRecrutador.findByEmail("recrutador@dataclick.com")).thenReturn(recrutador);

        UserDetails user = serviceAuthorization.loadUserByUsername("recrutador@dataclick.com");

        assertNotNull(user);
        assertEquals("recrutador@dataclick.com", user.getUsername());
        verify(repositoryAdministrador, times(1)).findByEmail("recrutador@dataclick.com");
        verify(repositoryRecrutador, times(1)).findByEmail("recrutador@dataclick.com");
    }

    @Test
    void deveLancarExcecaoQuandoUsuarioNaoForEncontrado() {
        when(repositoryAdministrador.findByEmail("naoexiste@dataclick.com")).thenReturn(null);
        when(repositoryRecrutador.findByEmail("naoexiste@dataclick.com")).thenReturn(null);

        assertThrows(UsernameNotFoundException.class, () -> {
            serviceAuthorization.loadUserByUsername("naoexiste@dataclick.com");
        });

        verify(repositoryAdministrador, times(1)).findByEmail("naoexiste@dataclick.com");
        verify(repositoryRecrutador, times(1)).findByEmail("naoexiste@dataclick.com");
    }

    @Test
    void deveRespeitarCaseSensitiveNoEmail() {
        when(repositoryAdministrador.findByEmail("ADMIN@DATACLICK.COM")).thenReturn(null);
        when(repositoryRecrutador.findByEmail("ADMIN@DATACLICK.COM")).thenReturn(null);

        assertThrows(UsernameNotFoundException.class, () -> {
            serviceAuthorization.loadUserByUsername("ADMIN@DATACLICK.COM");
        });

        verify(repositoryAdministrador).findByEmail("ADMIN@DATACLICK.COM");
        verify(repositoryRecrutador).findByEmail("ADMIN@DATACLICK.COM");
    }

    @Test
    void deveRetornarAuthoritiesCorretasParaAdmin() {
        when(repositoryAdministrador.findByEmail("admin@dataclick.com")).thenReturn(admin);

        UserDetails user = serviceAuthorization.loadUserByUsername("admin@dataclick.com");

        assertEquals(1, user.getAuthorities().size());
        assertEquals("ROLE_ADMIN", user.getAuthorities().iterator().next().getAuthority());
    }

    @Test
    void deveLancarExcecaoParaEmailNulo() {
        assertThrows(UsernameNotFoundException.class, () -> {
            serviceAuthorization.loadUserByUsername(null);
        });
    }

}

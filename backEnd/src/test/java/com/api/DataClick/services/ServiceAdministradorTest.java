package com.api.DataClick.services;

import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryAdministrador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class ServiceAdministradorTest {

    @Mock
    private RepositoryAdministrador repositoryAdministrador;

    @InjectMocks
    private ServiceAdministrador serviceAdministrador;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void removerAdm_deletebyid() {
        String admId = "testAdminId";
        doNothing().when(repositoryAdministrador).deleteById(admId);
        serviceAdministrador.removerAdm(admId);
        verify(repositoryAdministrador, times(1)).deleteById(admId);
    }

    @Test
    void infoAdm_retornaAdminQuandoExiste() {
        String admId = "testAdminId";
        EntityAdministrador admin = new EntityAdministrador("68848384000130", "fulano", "123456", "44998374906", "teste@gmail.com", UserRole.ADMIN);
        admin.setUsuarioId(admId);
        when(repositoryAdministrador.findById(admId)).thenReturn(Optional.of(admin));

        EntityAdministrador result = serviceAdministrador.infoAdm(admId);

        assertNotNull(result);
        assertEquals(admId, result.getUsuarioId());
        verify(repositoryAdministrador, times(1)).findById(admId);
    }

    @Test
    void infoAdm_lancaExceptionQuandoNaoExiste() {
        String admId = "nonExistentAdminId";
        when(repositoryAdministrador.findById(admId)).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceAdministrador.infoAdm(admId);
        });
        verify(repositoryAdministrador, times(1)).findById(admId);
    }

    @Test
    void alterarEmail_updateEmailQuandoAdminExiste() {
        String admId = "testAdminId";
        String newEmail = "newemail@example.com";
        EntityAdministrador admin = new EntityAdministrador("68848384000130", "fulano", "123456", "44998374906", "teste@gmail.com", UserRole.ADMIN);
        admin.setUsuarioId(admId);
        admin.setEmail("oldemail@example.com");

        when(repositoryAdministrador.findById(admId)).thenReturn(Optional.of(admin));
        when(repositoryAdministrador.save(any(EntityAdministrador.class))).thenReturn(admin);

        serviceAdministrador.alterarEmail(newEmail, admId);

        assertEquals(newEmail, admin.getEmail());
        verify(repositoryAdministrador, times(1)).findById(admId);
        verify(repositoryAdministrador, times(1)).save(admin);
    }

    @Test
    void alterarEmail_lancaExceptionQuandoAdminNaoExiste() {
        String admId = "nonExistentAdminId";
        String newEmail = "newemail@example.com";
        when(repositoryAdministrador.findById(admId)).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceAdministrador.alterarEmail(newEmail, admId);
        });
        verify(repositoryAdministrador, times(1)).findById(admId);
        verify(repositoryAdministrador, never()).save(any(EntityAdministrador.class));
    }

    @Test
    void alterarSenha_alteraSenhaQuandoAdminExiste() {
        String admId = "testAdminId";
        String newPassword = "newPassword123";
        EntityAdministrador admin = new EntityAdministrador("68848384000130", "fulano", "123456", "44998374906", "teste@gmail.com", UserRole.ADMIN);
        admin.setUsuarioId(admId);
        admin.setSenha("oldPassword");

        when(repositoryAdministrador.findById(admId)).thenReturn(Optional.of(admin));
        when(repositoryAdministrador.save(any(EntityAdministrador.class))).thenReturn(admin);

        serviceAdministrador.alterarSenha(newPassword, admId);

        assertEquals(newPassword, admin.getSenha());
        verify(repositoryAdministrador, times(1)).findById(admId);
        verify(repositoryAdministrador, times(1)).save(admin);
    }

    @Test
    void alterarSenha_lancaExceptionQuandoAdminNaoExiste() {
        String admId = "nonExistentAdminId";
        String newPassword = "newPassword123";
        when(repositoryAdministrador.findById(admId)).thenReturn(Optional.empty());

        assertThrows(ExeptionNaoEncontrado.class, () -> {
            serviceAdministrador.alterarSenha(newPassword, admId);
        });
        verify(repositoryAdministrador, times(1)).findById(admId);
        verify(repositoryAdministrador, never()).save(any(EntityAdministrador.class));
    }
}

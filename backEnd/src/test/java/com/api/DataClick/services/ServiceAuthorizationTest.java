package com.api.DataClick.services;

import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class ServiceAuthorizationTest {

    @Mock
    private RepositoryRecrutador repositoryRecrutador;

    @Mock
    private RepositoryAdministrador repositoryAdministrador;

    @InjectMocks
    private ServiceAuthorization serviceAuthorization;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void ReturnAdminDetails_whenAdminExists() {
        String username = "admin@example.com";
        UserDetails mockUserDetails = mock(UserDetails.class);
        when(repositoryAdministrador.findByEmail(username)).thenReturn(mockUserDetails);

        UserDetails result = serviceAuthorization.loadUserByUsername(username);

        assertNotNull(result);
        assertEquals(mockUserDetails, result);
        verify(repositoryAdministrador, times(1)).findByEmail(username);
        verify(repositoryRecrutador, never()).findByEmail(anyString());
    }

    @Test
    void ReturnRecruiterDetails_whenAdminNotFoundAndRecruiterExists() {
        String username = "recruiter@example.com";
        UserDetails mockUserDetails = mock(UserDetails.class);
        when(repositoryAdministrador.findByEmail(username)).thenReturn(null);
        when(repositoryRecrutador.findByEmail(username)).thenReturn(mockUserDetails);

        UserDetails result = serviceAuthorization.loadUserByUsername(username);

        assertNotNull(result);
        assertEquals(mockUserDetails, result);
        verify(repositoryAdministrador, times(1)).findByEmail(username);
        verify(repositoryRecrutador, times(1)).findByEmail(username);
    }

    @Test
    void ThrowUsernameNotFoundException_whenUserNotFound() {
        String username = "unknown@example.com";
        when(repositoryAdministrador.findByEmail(username)).thenReturn(null);
        when(repositoryRecrutador.findByEmail(username)).thenReturn(null);

        assertThrows(UsernameNotFoundException.class, () -> {
            serviceAuthorization.loadUserByUsername(username);
        });

        verify(repositoryAdministrador, times(1)).findByEmail(username);
        verify(repositoryRecrutador, times(1)).findByEmail(username);
    }
}

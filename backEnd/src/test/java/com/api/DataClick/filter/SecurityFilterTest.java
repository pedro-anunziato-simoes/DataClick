package com.api.DataClick.filter;

import com.api.DataClick.services.ServiceAuthorization;
import com.api.DataClick.services.ServiceToken;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;

import jakarta.servlet.FilterChain;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class SecurityFilterTest {

    @Mock
    private ServiceToken tokenService;

    @Mock
    private ServiceAuthorization authorizationService;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private FilterChain filterChain;

    @InjectMocks
    private SecurityFilter securityFilter;

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void deveRecuperarTokenQuandoHeaderValido() throws Exception {
        when(request.getHeader("Authorization")).thenReturn("Bearer validToken");

        securityFilter.doFilterInternal(request, response, filterChain);

        verify(tokenService).validateToken("validToken");
    }

    @Test
    void deveIgnorarQuandoHeaderAusente() throws Exception {
        when(request.getHeader("Authorization")).thenReturn(null);

        securityFilter.doFilterInternal(request, response, filterChain);

        verifyNoInteractions(tokenService, authorizationService);
        verify(filterChain).doFilter(request, response);
    }

    @Test
    void deveConfigurarAutenticacaoQuandoTokenValido() throws Exception {
        UserDetails userDetails = User.withUsername("user@test.com")
                .password("password")
                .roles("USER")
                .build();

        when(request.getHeader("Authorization")).thenReturn("Bearer validToken");
        when(tokenService.validateToken("validToken")).thenReturn("user@test.com");
        when(authorizationService.loadUserByUsername("user@test.com")).thenReturn(userDetails);

        securityFilter.doFilterInternal(request, response, filterChain);

        assertNotNull(SecurityContextHolder.getContext().getAuthentication());
        verify(filterChain).doFilter(request, response);
    }

    @Test
    void deveRetornarErro401QuandoTokenInvalido() throws Exception {
        when(request.getHeader("Authorization")).thenReturn("Bearer invalidToken");
        when(tokenService.validateToken("invalidToken")).thenThrow(new RuntimeException("Token inválido"));

        securityFilter.doFilterInternal(request, response, filterChain);

        verify(response).sendError(HttpServletResponse.SC_UNAUTHORIZED, "Token inválido");
        verify(filterChain, never()).doFilter(request, response);
    }


    @Test
    void deveLancarExcecaoQuandoUsuarioNaoEncontrado() throws Exception {
        when(request.getHeader("Authorization")).thenReturn("Bearer validToken");
        when(tokenService.validateToken("validToken")).thenReturn("user@test.com");
        when(authorizationService.loadUserByUsername("user@test.com"))
                .thenThrow(new RuntimeException("Usuário não encontrado"));

        securityFilter.doFilterInternal(request, response, filterChain);

        verify(response).sendError(HttpServletResponse.SC_UNAUTHORIZED, "Token inválido");
    }
}

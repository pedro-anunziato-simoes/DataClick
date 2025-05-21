package com.api.DataClick.filter;

import com.api.DataClick.services.ServiceAuthorization;
import com.api.DataClick.services.ServiceToken;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.IOException;
import java.util.Collections;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;


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

    private final String validToken = "valid.token.here";
    private final String userEmail = "user@example.com";

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        SecurityContextHolder.clearContext();
    }

    @Test
    void doFilterInternal_ComTokenValido_DeveAutenticarUsuario() throws Exception {
        when(request.getHeader("Authorization")).thenReturn("Bearer " + validToken);
        when(tokenService.validateToken(validToken)).thenReturn(userEmail);

        UserDetails userDetails = User.withUsername(userEmail)
                .password("password")
                .authorities(Collections.emptyList())
                .build();
        when(authorizationService.loadUserByUsername(userEmail)).thenReturn(userDetails);

        securityFilter.doFilterInternal(request, response, filterChain);

        assertNotNull(SecurityContextHolder.getContext().getAuthentication());
        verify(filterChain).doFilter(request, response);
    }

    @Test
    void doFilterInternal_ComTokenInvalido_DeveRetornar401() throws Exception {
        when(request.getHeader("Authorization")).thenReturn("Bearer invalid.token");
        when(tokenService.validateToken("invalid.token")).thenThrow(new RuntimeException("Token inválido"));

        securityFilter.doFilterInternal(request, response, filterChain);

        verify(response).sendError(eq(401), eq("Token inválido"));
        verify(filterChain, never()).doFilter(request, response);
    }

    @Test
    void doFilterInternal_SemToken_DeveContinuarChain() throws Exception {
        when(request.getHeader("Authorization")).thenReturn(null);

        securityFilter.doFilterInternal(request, response, filterChain);

        assertNull(SecurityContextHolder.getContext().getAuthentication());
        verify(filterChain).doFilter(request, response);
    }

    @Test
    void recoverToken_DeveExtrairTokenDoHeader() {
        SecurityFilter filter = new SecurityFilter(tokenService, authorizationService);
        when(request.getHeader("Authorization")).thenReturn("Bearer " + validToken);

        String token = filter.recoverToken(request);

        assertEquals(validToken, token);
    }

    @Test
    void recoverToken_HeaderSemBearer_DeveRetornarNull() {
        SecurityFilter filter = new SecurityFilter(tokenService, authorizationService);
        when(request.getHeader("Authorization")).thenReturn(validToken); // Sem "Bearer "

        String token = filter.recoverToken(request);

        assertNull(token);
    }
}

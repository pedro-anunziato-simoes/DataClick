package com.api.DataClick.services;

import com.api.DataClick.Security.SecurityProperties;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.enums.UserRole;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;


public class ServiceTokenTest {

    private ServiceToken serviceToken;
    private final String SECRET_KEY = "chaveSecretaMuitoLongaParaTestes1234567890abcdefghijklmnopqrstuvwxyz";

    @Mock
    private SecurityProperties securityProperties;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        when(securityProperties.getSECRET_KEY()).thenReturn(SECRET_KEY);
        serviceToken = new ServiceToken(securityProperties);
    }

    @Test
    void deveGerarTokenValidoComUsuarioIdQuandoUsuarioEntity() {
        EntityAdministrador usuario = new EntityAdministrador(
                "12345678000100",
                "Admin Test",
                "password",
                "44999999999",
                "admin@test.com",
                UserRole.ADMIN
        );

        String token = serviceToken.generateToken(usuario);
        Claims claims = parseToken(token);

        assertAll(
                () -> assertEquals(usuario.getEmail(), claims.getSubject()),
                () -> assertEquals(usuario.getUsuarioId(), claims.get("usuarioId")),
                () -> assertTrue(claims.get("authorities", List.class).contains("ROLE_ADMIN"))
        );
    }

    @Test
    void deveGerarTokenSemUsuarioIdParaUserPadrao() {
        UserDetails userDetails = User.builder()
                .username("user@test.com")
                .password("password")
                .authorities("ROLE_USER")
                .build();

        String token = serviceToken.generateToken(userDetails);
        Claims claims = parseToken(token);

        assertNull(claims.get("usuarioId"));
    }

    @Test
    void deveIncluirClaimsAdicionais() {
        UserDetails userDetails = User.builder()
                .username("user@test.com")
                .password("password")
                .authorities("ROLE_USER")
                .build();

        Map<String, Object> extraClaims = new HashMap<>();
        extraClaims.put("empresa", "DataClick");

        String token = serviceToken.generateToken(extraClaims, userDetails);
        Claims claims = parseToken(token);

        assertEquals("DataClick", claims.get("empresa"));
    }

    @Test
    void deveValidarTokenCorretamente() {
        UserDetails userDetails = User.builder()
                .username("user@test.com")
                .password("password")
                .authorities("ROLE_USER")
                .build();

        String token = serviceToken.generateToken(userDetails);

        assertEquals("user@test.com", serviceToken.validateToken(token));
    }



    @Test
    void deveUsarChaveCorretaParaAssinatura() {
        UserDetails user = User.builder()
                .username("test@test.com")
                .password("pass")
                .authorities("ROLE_USER")
                .build();

        String token = serviceToken.generateToken(user);

        assertDoesNotThrow(() -> parseToken(token));
    }

    private Claims parseToken(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(SECRET_KEY.getBytes())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
}

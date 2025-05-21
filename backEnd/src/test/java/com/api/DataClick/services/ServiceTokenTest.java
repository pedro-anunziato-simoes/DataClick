package com.api.DataClick.services;

import com.api.DataClick.Security.SecurityProperties;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.enums.UserRole;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SignatureException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;

import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
public class ServiceTokenTest {


    private ServiceToken serviceToken;
    private SecurityProperties securityProperties;
    private EntityAdministrador admin;
    private EntityRecrutador recrutador;

    @BeforeEach
    void setUp() {
        securityProperties = new SecurityProperties();
        securityProperties.setSECRET_KEY("chave-secreta-muito-longa-para-testes-1234567890");
        serviceToken = new ServiceToken(securityProperties);

        admin = new EntityAdministrador(
                "12345678900",
                "Admin Teste",
                "senha123",
                "11999998888",
                "admin@test.com",
                UserRole.ADMIN
        );
        admin.setUsuarioId("adm-001");

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
    void generateToken_ShouldIncludeUsuarioId_WhenUserIsSubclassOfUsuario() {
        String adminToken = serviceToken.generateToken(admin);
        String recrutadorToken = serviceToken.generateToken(recrutador);

        Claims adminClaims = parseToken(adminToken);
        Claims recrutadorClaims = parseToken(recrutadorToken);

        assertAll(
                () -> assertEquals("adm-001", adminClaims.get("usuarioId")),
                () -> assertEquals("rec-001", recrutadorClaims.get("usuarioId"))
        );
    }

    @Test
    void generateToken_ShouldIncludeCorrectAuthorities() {
        String token = serviceToken.generateToken(admin);
        Claims claims = parseToken(token);

        List<String> authorities = claims.get("authorities", List.class);
        assertIterableEquals(List.of("ROLE_ADMIN"), authorities);
    }

    @Test
    void generateToken_ShouldSetCorrectExpiration() {
        String token = serviceToken.generateToken(recrutador);
        Claims claims = parseToken(token);

        Date expiration = claims.getExpiration();
        Date issuedAt = claims.getIssuedAt();

        long duration = expiration.getTime() - issuedAt.getTime();
        assertEquals(86400000, duration, 1000); // 24h ±1s
    }

    @Test
    void validateToken_ShouldReturnEmailAsSubject() {
        String token = serviceToken.generateToken(admin);
        String subject = serviceToken.validateToken(token);
        assertEquals("admin@test.com", subject);
    }

    @Test
    void validateToken_ShouldThrowOnInvalidSignature() {
        String INVALID_SECRET = "chave-invalida-muito-longa-para-testes-123456789";

        String invalidToken = Jwts.builder()
                .setSubject("hacker@test.com")
                .signWith(Keys.hmacShaKeyFor(INVALID_SECRET.getBytes(StandardCharsets.UTF_8)))
                .compact();

        assertThrows(SignatureException.class, () ->
                serviceToken.validateToken(invalidToken)
        );
    }

    @Test
    void validateToken_ShouldThrowOnExpiredToken() {
        String expiredToken = Jwts.builder()
                .setSubject(recrutador.getEmail())
                .setIssuedAt(new Date(System.currentTimeMillis() - 20000))
                .setExpiration(new Date(System.currentTimeMillis() - 10000))
                .signWith(serviceToken.getSignInKey())
                .compact();

        assertThrows(ExpiredJwtException.class, () ->
                serviceToken.validateToken(expiredToken)
        );
    }

    @Test
    void generateToken_ShouldWorkWithGenericUserDetails() {
        UserDetails user = User.builder()
                .username("generic@user.com")
                .password("password")
                .authorities(() -> "ROLE_GUEST")
                .build();

        String token = serviceToken.generateToken(user);
        Claims claims = parseToken(token);

        assertAll(
                () -> assertEquals("generic@user.com", claims.getSubject()),
                () -> assertNull(claims.get("usuarioId")),
                () -> assertEquals(List.of("ROLE_GUEST"), claims.get("authorities"))
        );
    }

    private Claims parseToken(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(securityProperties.getSECRET_KEY().getBytes(StandardCharsets.UTF_8))
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
}

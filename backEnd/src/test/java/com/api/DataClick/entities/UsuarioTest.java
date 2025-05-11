package com.api.DataClick.entities;

import com.api.DataClick.enums.UserRole;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import static org.junit.jupiter.api.Assertions.*;

public class UsuarioTest {

    private ConcreteUsuario usuario;
    private final String EMAIL = "test@example.com";
    private final String SENHA = "senhaSegura123";

    private static class ConcreteUsuario extends Usuario {
        public ConcreteUsuario(String nome, String senha, String telefone, String email, UserRole role) {
            super(nome, senha, telefone, email, role);
        }
    }

    @BeforeEach
    void setUp() {
        usuario = new ConcreteUsuario(
                "Usuário Teste",
                SENHA,
                "(11) 91234-5678",
                EMAIL,
                UserRole.ADMIN
        );
    }

    @Test
    void setRole_DeveAlterarPermissoesDoUsuario() {
        UserRole novoRole = UserRole.USER;

        usuario.setRole(novoRole);

        assertAll(
                () -> assertEquals(novoRole, usuario.getRole()),
                () -> assertTrue(usuario.getAuthorities().contains(
                                new SimpleGrantedAuthority(novoRole.getRole())
                        )
                   )
                );
    }

    @Test
    void getPassword_DeveRetornarSenhaCorreta() {
        assertEquals(SENHA, usuario.getPassword());
    }

    @Test
    void isAccountNonLocked_DeveRetornarTrue() {
        assertTrue(usuario.isAccountNonLocked());
    }

    @Test
    void isCredentialsNonExpired_DeveRetornarTrue() {
        assertTrue(usuario.isCredentialsNonExpired());
    }

    @Test
    void isEnabled_DeveRetornarTrue() {
        assertTrue(usuario.isEnabled());
    }
}

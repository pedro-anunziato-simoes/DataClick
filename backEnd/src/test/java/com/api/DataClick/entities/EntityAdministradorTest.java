package com.api.DataClick.entities;

import com.api.DataClick.enums.UserRole;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class EntityAdministradorTest {

    private EntityAdministrador administrador;
    private final String CNPJ_VALIDO = "12345678901234";
    private final String NOVO_CNPJ = "98765432109876";

    @BeforeEach
    void setUp() {
        administrador = new EntityAdministrador(
                CNPJ_VALIDO,
                "Admin Teste",
                "senha123",
                "11999998888",
                "admin@empresa.com",
                UserRole.ADMIN
        );
    }

    @Test
    void getCnpj_DeveRetornarCnpjCorreto() {
        assertEquals(CNPJ_VALIDO, administrador.getCnpj(),
                "O CNPJ deve corresponder ao valor inicial");
    }

    @Test
    void setCnpj_DeveAlterarValorCorretamente() {
        administrador.setCnpj(NOVO_CNPJ);

        assertAll(
                () -> assertEquals(NOVO_CNPJ, administrador.getCnpj(),
                        "O CNPJ deve ser atualizado corretamente"),

                () -> assertNotEquals(CNPJ_VALIDO, administrador.getCnpj(),
                        "O CNPJ não deve mais ser o valor original")
        );
    }

    @Test
    void construtor_DeveInicializarColecoesCorretamente() {
        assertAll(
                () -> assertNotNull(administrador.getAdminRecrutadores(),
                        "A lista de recrutadores deve ser inicializada"),

                () -> assertTrue(administrador.getAdminRecrutadores().isEmpty(),
                        "A lista de recrutadores deve começar vazia"),

                () -> assertNotNull(administrador.getAdminEventos(),
                        "A lista de eventos deve ser inicializada"),

                () -> assertTrue(administrador.getAdminEventos().isEmpty(),
                        "A lista de eventos deve começar vazia")
        );
    }
}

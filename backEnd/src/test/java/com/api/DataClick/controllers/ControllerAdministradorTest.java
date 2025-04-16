package com.api.DataClick.controllers;

import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.enums.UserRole;
import com.api.DataClick.services.ServiceAdministrador;
import com.api.DataClick.services.ServiceRecrutador;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.http.ResponseEntity;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

public class ControllerAdministradorTest {

    private MockMvc mockMvc;

    @Mock
    private ServiceAdministrador serviceAdministrador;

    @Mock
    private ServiceRecrutador serviceRecrutador;

    @InjectMocks
    private ControllerAdministrador controllerAdministrador;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        mockMvc = MockMvcBuilders.standaloneSetup(controllerAdministrador).build();
    }

    @Test
    void testListarAdministradores() throws Exception {
        EntityAdministrador administrador1 = new EntityAdministrador(
                "12345678000195",
                "Admin 1",
                "senha123",
                "123456789",
                "admin1@empresa.com",
                UserRole.ADMIN
        );
        EntityAdministrador administrador2 = new EntityAdministrador(
                "12345678000196",
                "Admin 2",
                "senha456",
                "987654321",
                "admin2@empresa.com",
                UserRole.ADMIN
        );
        List<EntityAdministrador> administradores = Arrays.asList(administrador1, administrador2);
        when(serviceAdministrador.listarAdministradores()).thenReturn(administradores);

        mockMvc.perform(get("/administradores"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].cnpj").value("12345678000195"))
                .andExpect(jsonPath("$[1].cnpj").value("12345678000196"))
                .andExpect(jsonPath("$[0].nome").value("Admin 1"))
                .andExpect(jsonPath("$[1].nome").value("Admin 2"));
    }

    @Test
    void testAdicionarAdministrador() throws Exception {
        EntityAdministrador novoAdministrador = new EntityAdministrador(
                "12345678000197",
                "Admin 3",
                "senha789",
                "112233445",
                "admin3@empresa.com",
                UserRole.ADMIN
        );
        when(serviceAdministrador.adicionarAdmin(any(EntityAdministrador.class))).thenReturn(novoAdministrador);

        mockMvc.perform(post("/administradores")
                        .contentType("application/json")
                        .content("{\"cnpj\": \"12345678000197\", \"nome\": \"Admin 3\", \"senha\": \"senha789\", \"telefone\": \"112233445\", \"email\": \"admin3@empresa.com\", \"role\": \"ADMIN\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.cnpj").value("12345678000197"))
                .andExpect(jsonPath("$.nome").value("Admin 3"));
    }

}

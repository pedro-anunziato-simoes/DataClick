package com.api.DataClick.repositories;


import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.enums.UserRole;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.data.mongo.DataMongoTest;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;


@DataMongoTest
public class RepositoryAdministradorTest {

    @Autowired
    private RepositoryAdministrador repository;

    @BeforeEach
    void setUp() {
        repository.deleteAll();
    }

    @Test
    void findByEmail_WhenAdminExists_ReturnsUserDetails() {
        EntityAdministrador admin = new EntityAdministrador(
                "123456789",
                "Admin Fulano",
                "senha123",
                "11999999999",
                "admin@teste.com",
                UserRole.ADMIN
        );
        repository.save(admin);

        UserDetails userDetails = repository.findByEmail("admin@teste.com");

        assertThat(userDetails).isNotNull();
        assertThat(userDetails.getUsername()).isEqualTo("admin@teste.com");
    }

    @Test
    void findByEmail_WhenAdminDoesNotExist_ReturnsNull() {
        UserDetails userDetails = repository.findByEmail("naoexiste@teste.com");
        assertThat(userDetails).isNull();
    }

    @Test
    void findById_WhenAdminExists_ReturnsAdmin() {
        EntityAdministrador admin = new EntityAdministrador(
                "987654321",
                "Admin Beltrano",
                "outrasenha",
                "11888888888",
                "admin2@teste.com",
                UserRole.ADMIN
        );
        EntityAdministrador savedAdmin = repository.save(admin);

        Optional<EntityAdministrador> foundAdmin = repository.findById(savedAdmin.getUsuarioId());

        assertThat(foundAdmin).isPresent();
        assertThat(foundAdmin.get().getUsuarioId()).isEqualTo(savedAdmin.getUsuarioId());
        assertThat(foundAdmin.get().getEmail()).isEqualTo("admin2@teste.com");
    }

    @Test
    void findById_WhenAdminDoesNotExist_ReturnsEmpty() {
        Optional<EntityAdministrador> foundAdmin = repository.findById("idInexistente");
        assertThat(foundAdmin).isEmpty();
    }
}

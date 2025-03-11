package com.api.DataClick.repositories;

import com.api.DataClick.entities.EntityAdministrador;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RepositoryAdministrador extends MongoRepository<EntityAdministrador,String> {
    Optional<EntityAdministrador> findByEmail(String email);
    Optional<EntityAdministrador> findById(String id);
}

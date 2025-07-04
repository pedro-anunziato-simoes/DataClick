package com.api.DataClick.repositories;

import com.api.DataClick.entities.EntityEvento;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface RepositoryEvento extends MongoRepository<EntityEvento,String> {
    Optional<List<EntityEvento>> findAllByEventoAdminId(String eventoAdminId);
}

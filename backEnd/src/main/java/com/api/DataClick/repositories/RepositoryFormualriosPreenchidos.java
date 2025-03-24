package com.api.DataClick.repositories;

import com.api.DataClick.entities.EntityFormualriosPreenchidos;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RepositoryFormualriosPreenchidos extends MongoRepository<EntityFormualriosPreenchidos,String> {
    Optional<List<EntityFormualriosPreenchidos>> findByrecrutadorId(String recrutadorId);
}
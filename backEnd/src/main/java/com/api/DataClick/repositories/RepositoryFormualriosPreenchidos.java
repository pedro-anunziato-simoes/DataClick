package com.api.DataClick.repositories;

import com.api.DataClick.entities.EntityFormulariosPreenchidos;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RepositoryFormualriosPreenchidos extends MongoRepository<EntityFormulariosPreenchidos,String> {
    Optional<List<EntityFormulariosPreenchidos>> findByrecrutadorId(String recrutadorId);
}
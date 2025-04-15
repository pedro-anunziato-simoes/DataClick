package com.api.DataClick.repositories;

import com.api.DataClick.entities.EntityCampo;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;


public interface RepositoryCampo extends MongoRepository<EntityCampo,String> {
    Optional<List<EntityCampo>> findAllByformId(String id);
}

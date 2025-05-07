package com.api.DataClick.repositories;

import com.api.DataClick.entities.EntityCampo;
import com.api.DataClick.entities.EntityEvento;
import com.api.DataClick.entities.EntityFormulario;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface RepositoryEvento extends MongoRepository<EntityEvento,String> {
    Optional<List<EntityEvento>> findAllByadminId(String id);
}

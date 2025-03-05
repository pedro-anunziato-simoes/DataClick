package com.api.DataClick.repositories;

import com.api.DataClick.entities.EntityFormulario;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RepositoryFormulario extends MongoRepository<EntityFormulario,String> {
}

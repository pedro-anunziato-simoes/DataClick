package com.api.DataClick.repositories;

import com.api.DataClick.entities.EntityAdministrador;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RepositoryAdministrador extends MongoRepository<EntityAdministrador,String> {
}

package com.api.DataClick.repositories;

import com.api.DataClick.entities.EntityRecrutador;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Repository;

@Repository
public interface RepositoryRecrutador extends MongoRepository<EntityRecrutador,String> {
    UserDetails findByEmail(String email);
}

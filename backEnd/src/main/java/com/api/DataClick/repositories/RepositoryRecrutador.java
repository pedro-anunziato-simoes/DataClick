package com.api.DataClick.repositories;

import com.api.DataClick.entities.EntityRecrutador;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RepositoryRecrutador extends MongoRepository<EntityRecrutador,String> {
    List<EntityRecrutador> findByAdministradorId(String administradorId);
}

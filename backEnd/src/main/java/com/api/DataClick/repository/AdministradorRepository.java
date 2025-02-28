package com.api.DataClick.repository;

import com.api.DataClick.entities.Administrador;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface AdministradorRepository extends MongoRepository<Administrador,Long> {
}

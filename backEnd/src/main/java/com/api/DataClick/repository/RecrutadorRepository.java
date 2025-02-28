package com.api.DataClick.repository;

import com.api.DataClick.entities.Recrutador;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface RecrutadorRepository extends MongoRepository<Recrutador,Long> {
}

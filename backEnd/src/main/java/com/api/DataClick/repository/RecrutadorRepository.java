package com.api.DataClick.repository;

import com.api.DataClick.entities.Recrutador;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RecrutadorRepository extends MongoRepository<Recrutador,Long> {
}

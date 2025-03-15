package com.api.DataClick.repositories;

import com.api.DataClick.entities.EntityResposta;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface RepositoryResposta extends MongoRepository<EntityResposta,String> {
}

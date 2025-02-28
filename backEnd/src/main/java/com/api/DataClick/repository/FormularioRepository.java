package com.api.DataClick.repository;

import com.api.DataClick.entities.Formulario;

import org.springframework.data.mongodb.repository.MongoRepository;

public interface FormularioRepository extends MongoRepository<Formulario,Long> {
}

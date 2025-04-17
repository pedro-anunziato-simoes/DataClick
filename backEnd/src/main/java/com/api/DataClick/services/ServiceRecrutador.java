package com.api.DataClick.services;

import com.api.DataClick.DTO.RecrutadorUpdateDTO;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryFormulario;
import com.api.DataClick.repositories.RepositoryRecrutador;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

@Service
public class ServiceRecrutador {

    @Autowired
    private RepositoryFormulario repositoryFormulario;
    @Autowired
    private RepositoryAdministrador repositoryAdministrador;
    @Autowired
    private RepositoryRecrutador repositoryRecrutador;


    public List<EntityRecrutador> listarTodosRecrutadores(){
        return repositoryRecrutador.findAll();
    }

    @Transactional
    public EntityRecrutador criarRecrutador(EntityRecrutador recrutador) {

        EntityRecrutador novoRecrutador = repositoryRecrutador.save(recrutador);

        if (novoRecrutador.getAdminId() != null) {
            EntityAdministrador administrador = repositoryAdministrador.findById(novoRecrutador.getAdminId())
                    .orElseThrow(() -> new ExeptionNaoEncontrado("Administrador não encontrado " + novoRecrutador.getAdminId()));

            administrador.getRecrutadores().add(novoRecrutador);
            repositoryAdministrador.save(administrador);
        }

        return novoRecrutador;
    }

    public void removerRecrutador(String recrutadorId) {
        repositoryRecrutador.deleteById(recrutadorId);
    }


    public List<EntityRecrutador> listarRecrutadores(String administradorId) {
        EntityAdministrador administrador = repositoryAdministrador.findById(administradorId)
                .orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.ADM_NAO_ENCONTRADO));

        return administrador.getRecrutadores();
    }

    public EntityRecrutador buscarRecrut(String id){
        EntityRecrutador recrutador = repositoryRecrutador.findById(id)
                .orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.REC_NAO_ENCONTRADO));
        return recrutador;
    }


    public Optional<String> buscarAdminIdPorRecrutadorId(String recrutadorId) {
        return repositoryRecrutador.findById(recrutadorId)
                .map(EntityRecrutador::getAdminId);
  
    public EntityRecrutador alterarRecrutador(String id, RecrutadorUpdateDTO dto){
        EntityRecrutador recrutador = repositoryRecrutador.findById(id)
                .orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.REC_NAO_ENCONTRADO));
        recrutador.setEmail(dto.getEmail());
        recrutador.setTelefone(dto.getTelefone());
        recrutador.setNome(dto.getNome());
        repositoryRecrutador.save(recrutador);
        return recrutador;

    }
}

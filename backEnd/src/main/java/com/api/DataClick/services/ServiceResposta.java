package com.api.DataClick.services;

import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.EntityResposta;
import com.api.DataClick.repositories.RepositoryResposta;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class ServiceResposta {

    @Autowired
    RepositoryResposta repositoryResposta;

    public List<EntityResposta> listarTodasRepostas(){
        return repositoryResposta.findAll();
    }

    public void SubirRespostas(List<EntityFormulario> formulariosPreenchidos){
        for(EntityFormulario formulario : formulariosPreenchidos){
            EntityResposta resposta = new EntityResposta(formulario);
            repositoryResposta.save(resposta);
        }
    }

    public void removerResposta(String repostaId){
        EntityResposta resposta = repositoryResposta.findById(repostaId).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Resposta não encontrada"));
        repositoryResposta.delete(resposta);
    }
}

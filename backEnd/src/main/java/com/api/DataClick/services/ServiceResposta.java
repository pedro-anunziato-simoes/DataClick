package com.api.DataClick.services;

import com.api.DataClick.entities.EntityCampo;
import com.api.DataClick.entities.EntityResposta;
import com.api.DataClick.enums.TipoCampo;
import com.api.DataClick.repositories.RepositoryCampo;
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

    public void registrarResposta(EntityCampo campo){
        EntityResposta resposta = new EntityResposta();
        TipoCampo tipo = campo.getResposta().getTipo();
        resposta.setTipo(tipo);
        repositoryResposta.save(resposta);
    }

    public List<EntityResposta> listarRespostas(){
        return repositoryResposta.findAll();
    }

    public void removerResposta(String id){
        repositoryResposta.delete(repositoryResposta.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Campo não encontrado")));
    }
}
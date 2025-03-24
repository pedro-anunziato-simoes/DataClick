package com.api.DataClick.services;

import com.api.DataClick.entities.EntityCampo;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.EntityResposta;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryCampo;
import com.api.DataClick.repositories.RepositoryFormulario;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class ServiceCampo {

    @Autowired
    RepositoryCampo repositoryCampo;
    @Autowired
    RepositoryFormulario repositoryFormulario;
    @Autowired
    ServiceResposta serviceResposta;

    public List<EntityCampo> listarTodosCampos(){
        return repositoryCampo.findAll();
    }

    public List<EntityCampo> listarCamposByFormularioId(String formId){
        return repositoryCampo.findAllByid(formId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.CAMPO_NAO_ENCONTRADO));
    }

    public EntityCampo adicionarCampo(EntityCampo campo, String formId) {
        EntityFormulario form = repositoryFormulario.findById(formId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.CAMPO_NAO_ENCONTRADO));
        serviceResposta.registrarResposta(campo);
        repositoryCampo.save(campo);
        form.getCampos().add(campo);
        repositoryFormulario.save(form);
        return campo;
    }

    public void removerCampo(String campoId){
        EntityCampo campo = repositoryCampo.findById(campoId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.CAMPO_NAO_ENCONTRADO));
        repositoryCampo.delete(campo);
    }

//    public EntityCampo preencherCampo(String campoId, EntityResposta resposta){
//        EntityCampo campo = repositoryCampo.findById(campoId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.CAMPO_NAO_ENCONTRADO));
//        campo.setResposta(resposta);
//        repositoryCampo.save(campo);
//        return campo;
//    }

}

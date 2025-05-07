package com.api.DataClick.services;

import com.api.DataClick.entities.EntityCampo;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.enums.TipoCampo;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryCampo;
import com.api.DataClick.repositories.RepositoryFormulario;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ServiceCampo {

    @Autowired
    RepositoryCampo repositoryCampo;
    @Autowired
    RepositoryFormulario repositoryFormulario;

    public List<EntityCampo> listarCamposByFormularioId(String formId){
        return repositoryCampo.findAllByformId(formId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.CAMPO_NAO_ENCONTRADO));
    }

    public EntityCampo adicionarCampo(EntityCampo campo, String formId) {
        EntityFormulario form = repositoryFormulario.findById(formId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.FORM_NAO_ENCONTRADO));
        String idForm = form.getFormId();
        campo.setCampoFormId(idForm);
        repositoryCampo.save(campo);
        form.getCampos().add(campo);
        repositoryFormulario.save(form);
        return campo;
    }

    public void removerCampo(String campoId){
        EntityCampo campo = repositoryCampo.findById(campoId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.CAMPO_NAO_ENCONTRADO));
        repositoryCampo.delete(campo);
    }

    public EntityCampo buscarCampoById(String id){
        return repositoryCampo.findById(id).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.CAMPO_NAO_ENCONTRADO));
    };

    public EntityCampo alterarCampo(String id, String tipo, String titulo){
        EntityCampo campo = repositoryCampo.findById(id).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.CAMPO_NAO_ENCONTRADO));
        System.out.println(tipo);
        campo.setCampoTipo(TipoCampo.valueOf(tipo));
        campo.setCampoTitulo(titulo);
        System.out.println(titulo);
        return repositoryCampo.save(campo);
    }
}

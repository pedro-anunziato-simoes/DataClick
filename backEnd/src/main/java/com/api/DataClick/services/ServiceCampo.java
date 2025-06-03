package com.api.DataClick.services;

import com.api.DataClick.DTO.CampoDTO;
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
        return repositoryCampo.findAllBycampoFormId(formId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.CAMPO_NAO_ENCONTRADO));
    }

    public EntityCampo adicionarCampo(CampoDTO dto, String formId) {
        EntityFormulario form = repositoryFormulario.findById(formId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.FORM_NAO_ENCONTRADO));
        EntityCampo campo = new EntityCampo(dto.getCampoTituloDto(), dto.getCampoTipoDto(),null);
        campo.setCampoFormId(formId);
        repositoryCampo.save(campo);
        form.getCampos().add(campo);
        repositoryFormulario.save(form);
        return campo;
    }

    public void removerCampo(String campoId){
        EntityCampo campo = repositoryCampo.findById(campoId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.CAMPO_NAO_ENCONTRADO));
        String id = campo.getCampoFormId();
        EntityFormulario form = repositoryFormulario.findById(id).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.FORM_NAO_ENCONTRADO));
        form.getCampos().remove(campo);
        repositoryFormulario.save(form);
        repositoryCampo.delete(campo);
    }

    public EntityCampo buscarCampoById(String id){
        return repositoryCampo.findById(id).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.CAMPO_NAO_ENCONTRADO));
    };

    public EntityCampo alterarCampo(String id,CampoDTO dto){
        EntityCampo campo = repositoryCampo.findById(id).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.CAMPO_NAO_ENCONTRADO));
        campo.setCampoTipo(dto.getCampoTipoDto());
        campo.setCampoTitulo(dto.getCampoTituloDto());
        return repositoryCampo.save(campo);
    }
}

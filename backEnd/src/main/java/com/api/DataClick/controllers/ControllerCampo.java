package com.api.DataClick.controllers;


import com.api.DataClick.entities.EntityCampo;
import com.api.DataClick.repositories.RepositoryCampo;
import com.api.DataClick.services.ServiceCampo;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/campos")
@Tag(name = "Campos", description = "Endpoints de funcionalidades de campos")
public class ControllerCampo {

    @Autowired
    private ServiceCampo serviceCampo;
    @Autowired
    private RepositoryCampo repositoryCampo;

    @GetMapping
    public List<EntityCampo> listarTodosCampos(){
        return  serviceCampo.listarTodosCampos();
    }

    @GetMapping("/findByFormId/{formId}")
    public List<EntityCampo> listarCamposPorFormularioId(@PathVariable String formId){
        return serviceCampo.listarCamposByFormularioId(formId);
    }

    @PostMapping("/add/{formId}")
    public EntityCampo adicionarCampoForm(@RequestBody EntityCampo campo,@PathVariable String formId){
        return serviceCampo.adicionarCampo(campo,formId);
    }

    @DeleteMapping("/remover/{campoId}")
    public void removerCampo(@PathVariable String campoId){
        serviceCampo.removerCampo(campoId);
    }

    @PostMapping("/preencher/{CampoId}")
    public EntityCampo preencherCampo(@PathVariable String CampoId,@RequestBody String resposta){
        return serviceCampo.preencherCampo(CampoId,resposta);
    }
}
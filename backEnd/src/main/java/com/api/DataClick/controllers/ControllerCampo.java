package com.api.DataClick.controllers;


import com.api.DataClick.entities.EntityCampo;
import com.api.DataClick.repositories.RepositoryCampo;
import com.api.DataClick.services.ServiceCampo;
import io.swagger.v3.oas.annotations.Operation;
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
    @Operation(summary = "Listar todos os campos", description = "Retorna todos os campos de todos os formularios")
    public List<EntityCampo> listarTodosCampos(){
        return  serviceCampo.listarTodosCampos();
    }

    @GetMapping("/findByFormId/{formId}")
    @Operation(summary = "Lista todos os campos pelo id do formulario", description = "Retorna todos os campos de um determinado formulario")
    public List<EntityCampo> listarCamposPorFormularioId(@PathVariable String formId){
        return serviceCampo.listarCamposByFormularioId(formId);
    }

    @PostMapping("/add/{formId}")
    @Operation(summary = "Adiciona um campo a um formulario", description = "Retorna o campo adicionado ao formulario")
    public EntityCampo adicionarCampoForm(@RequestBody EntityCampo campo,@PathVariable String formId){
        return serviceCampo.adicionarCampo(campo,formId);
    }

    @DeleteMapping("/remover/{campoId}")
    @Operation(summary = "Remover campo", description = "remove um campo de um formulario pelo id do campo")
    public void removerCampo(@PathVariable String campoId){
        serviceCampo.removerCampo(campoId);
    }

//    @PostMapping("/preencher/{CampoId}")
//    @Operation(summary = "Preenche um campo de um formulario", description = "retorna o campo preenchido ")
//    public EntityCampo preencherCampo(@PathVariable String CampoId,@RequestBody EntityResposta resposta){
//        return serviceCampo.preencherCampo(CampoId,resposta);
//    }
}
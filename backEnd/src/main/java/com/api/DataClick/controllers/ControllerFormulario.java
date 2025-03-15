package com.api.DataClick.controllers;

import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.services.ServiceFormulario;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/formularios")
@Tag(name = "Formularios", description = "Endpoints de funcionalidades de formularios")
public class ControllerFormulario {

    @Autowired
    ServiceFormulario serviceFormulario;

    @GetMapping
    @Operation(summary = "Listar todos os formularios", description = "Retorna todos os formularios salvos no banco de dados")
    public List<EntityFormulario> listarFormularios(){
        return serviceFormulario.listarFormularios();
    }

    @PostMapping("/formularios/add/{adminId}")
    @Operation(summary = "Criar formulario", description = "Retorna o formulario salvo/criado no banco de dados")
    public EntityFormulario criarFormulario(@RequestBody EntityFormulario form, @PathVariable String adminId){
        return serviceFormulario.criarFormulario(form,adminId);
    }

    @DeleteMapping("/formualrio/remove/{id}")
    @Operation(summary = "Deleta/remover formulario", description = "Deleta o formulario do banco de dados e retira ele da lista de fomrulario dos admintradores/recrutadores")
    public void removerFormulario(String formId){
        serviceFormulario.removerFormulario(formId);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Busca um formulario pelo id-formulario", description = "Retorna um formaulario cujo id foi inserido")
    public EntityFormulario buscarForm(String formId){
       return serviceFormulario.bucarFormPorId(formId);
    }

    @GetMapping("/findByAdmin/{id}")
    @Operation(summary = "Busca a lista de formularios pelo id-adminitrador", description = "Retorna uma lista de formularios vinculada ao adminitrador")
    public List<EntityFormulario> buscarFormByAdminId(@PathVariable String id){
        return serviceFormulario.buscarFormPorAdminId(id);
    }
}

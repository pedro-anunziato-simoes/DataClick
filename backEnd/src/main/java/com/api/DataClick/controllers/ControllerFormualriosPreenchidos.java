package com.api.DataClick.controllers;

import com.api.DataClick.entities.EntityFormualriosPreenchidos;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.services.ServiceFormulariosPreenchidos;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/formualriosPreenchidos")
@Tag(name = "FormualriosPreenchidos", description = "Endpoints de funcionalidades dos FormualriosPreenchidos")
public class ControllerFormualriosPreenchidos {

    @Autowired
    ServiceFormulariosPreenchidos serviceFormulariosPreenchidos;

    @GetMapping
    public List<EntityFormualriosPreenchidos> listarTodosFormualriosPreenchidos(){
        return serviceFormulariosPreenchidos.listarTodosFormulariosPreenchidos();
    }

    @GetMapping("/{recrtuadorId}")
    public List<EntityFormualriosPreenchidos> buscarFormByRecrutadorId(String recrtuadorId){
        return serviceFormulariosPreenchidos.buscarListaDeFormualriosPorIdRecrutador(recrtuadorId);
    }

    @PostMapping("/add/{recrutadorId}")
    public EntityFormualriosPreenchidos adicionarFormualriosPreenchidos( @RequestBody EntityFormualriosPreenchidos forms, @PathVariable String recrutadorId){
        return serviceFormulariosPreenchidos.adicionarFormulariosPreenchidos(forms,recrutadorId);
    }

}

package com.api.DataClick.controllers;

import com.api.DataClick.entities.EntityFormualriosPreenchidos;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.services.ServiceFormulariosPreenchidos;
import io.swagger.v3.oas.annotations.Operation;
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
    @Operation(summary = "Listar todas as respostas", description = "Realiza uma busca retornando todas as vezes que foram enviadas listas de formualrios e por qual recrutador foi enviado e a qual admin ele pertence")
    public List<EntityFormualriosPreenchidos> listarTodosFormualriosPreenchidos(){
        return serviceFormulariosPreenchidos.listarTodosFormulariosPreenchidos();
    }

    @GetMapping("/{recrtuadorId}")
    @Operation(summary = "Buscar formulario por recrutador", description = "Retorna a lista de formularios que foram preenchidas pelo recrutador buscado")
    public List<EntityFormualriosPreenchidos> buscarFormByRecrutadorId(String recrtuadorId){
        return serviceFormulariosPreenchidos.buscarListaDeFormualriosPorIdRecrutador(recrtuadorId);
    }

    @PostMapping("/add/{recrutadorId}")
    @Operation(summary = "Adicionar lista de formualrios preenchidos", description = "Adiciona uma lista de fomularios ao banco de dados com a identificação do recrutador que preencheu os formularios e o adminitrador no qual o recrutador faz parte")
    public EntityFormualriosPreenchidos adicionarFormualriosPreenchidos( @RequestBody EntityFormualriosPreenchidos forms, @PathVariable String recrutadorId){
        return serviceFormulariosPreenchidos.adicionarFormulariosPreenchidos(forms,recrutadorId);
    }

}

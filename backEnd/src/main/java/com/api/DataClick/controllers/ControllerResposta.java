package com.api.DataClick.controllers;

import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.EntityResposta;
import com.api.DataClick.services.ServiceResposta;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/resposta")
@Tag(name = "Respostas", description = "Endpoints de funcionalidades de resposta dos formularios")
public class ControllerResposta {

    @Autowired
    ServiceResposta serviceResposta;

    @GetMapping
    @Operation(summary = "Lista todas as respostas", description = "retorna a lista de respostas")
    public List<EntityResposta> listarRespostas(){
        return serviceResposta.listarRespostas();
    }

    @DeleteMapping
    @Operation(summary = "deleta uma resposta", description = "deleta uma resposta")
    public void deletarRespostas(String id){
        serviceResposta.removerResposta(id);
    }
}

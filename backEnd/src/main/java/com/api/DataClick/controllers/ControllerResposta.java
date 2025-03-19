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
    @Operation(summary = "Listar respostas", description = "retorna todos as respostas salvas no banco")
    public List<EntityResposta> listarTodasRespostas(){
        return serviceResposta.listarTodasRepostas();
    }

    @PostMapping("/add")
    @Operation(summary = "Salva uma resposta no banco", description = "retorna a reposta salva no banco")
    public void SubirRespostas(@RequestBody List<EntityFormulario> formulariosPreenchidos){
        serviceResposta.SubirRespostas(formulariosPreenchidos);
    }

    @DeleteMapping("/remove/{respostaId}")
    @Operation(summary = "remover resposta", description = "Remove a resposta do banco")
    public void removerResposta(@PathVariable String respostaId){
        serviceResposta.removerResposta(respostaId);
    }

}

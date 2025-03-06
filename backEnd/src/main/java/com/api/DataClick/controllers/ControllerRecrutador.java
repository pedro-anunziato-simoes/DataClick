package com.api.DataClick.controllers;

import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.services.ServiceRecrutador;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/recrutadores")
@Tag(name = "Recrutadores", description = "Endpoints de funcionalidades de recrutadores")
public class ControllerRecrutador {

    @Autowired
    private ServiceRecrutador serviceRecrutador;

    @GetMapping("/formularios")
    @Operation(summary = "Listar todos os formularios", description = "Retorna uma lista de forularios")
    public List<EntityFormulario> listarFormularios(){
        return serviceRecrutador.listarFormulario();
    }

}

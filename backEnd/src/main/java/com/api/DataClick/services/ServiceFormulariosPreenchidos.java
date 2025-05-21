package com.api.DataClick.services;

import com.api.DataClick.DTO.FormularioPreenchidosDTO;
import com.api.DataClick.entities.EntityFormulario;
import com.api.DataClick.entities.EntityFormulariosPreenchidos;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryFormualriosPreenchidos;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ServiceFormulariosPreenchidos {

    @Autowired
    private RepositoryFormualriosPreenchidos repositoryFormualriosPreenchidos;
    @Autowired
    private RepositoryRecrutador repositoryRecrutador;

    public EntityFormulariosPreenchidos adicionarFomulariosPreenchidos(FormularioPreenchidosDTO formulariosPreenchidos){
        List<EntityFormulario> forms = formulariosPreenchidos.getFormulariosPreenchidosDtoListForms();
        EntityFormulariosPreenchidos formsPreenchidos = new EntityFormulariosPreenchidos("",new ArrayList<>());
        formsPreenchidos.setFormularioPreenchidoListaFormularios(forms);
        for(EntityFormulario form : forms){
            String eventoId = form.getFormularioEventoId();
            formsPreenchidos.setFormularioPreenchidoEventoId(eventoId);
            break;
        }
        return repositoryFormualriosPreenchidos.save(formsPreenchidos);
    }

    public List<EntityFormulariosPreenchidos> buscarFormualriosPreechidosPorEvento(String eventoId){
        return repositoryFormualriosPreenchidos.findByformularioPreenchidoEventoId(eventoId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.EVENTO_NAO_ENCONTRADO));
    }

}

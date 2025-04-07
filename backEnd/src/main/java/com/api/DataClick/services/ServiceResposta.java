package com.api.DataClick.services;

import com.api.DataClick.entities.EntityCampo;
import com.api.DataClick.entities.EntityResposta;
import com.api.DataClick.enums.TipoCampo;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class ServiceResposta {
    public void registrarResposta(EntityCampo campo){
        EntityResposta resposta = new EntityResposta();
        TipoCampo tipo = campo.getResposta().getTipo();
        resposta.setTipo(tipo);
    }

}
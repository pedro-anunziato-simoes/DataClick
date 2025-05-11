package com.api.DataClick.services;

import com.api.DataClick.DTO.RecrutadorDTO;
import com.api.DataClick.entities.EntityAdministrador;
import com.api.DataClick.entities.EntityRecrutador;
import com.api.DataClick.exeptions.ExeceptionsMensage;
import com.api.DataClick.exeptions.ExeptionNaoEncontrado;
import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryRecrutador;
import lombok.Generated;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Generated
public class ServiceRecrutador {

    @Autowired
    private RepositoryAdministrador repositoryAdministrador;
    @Autowired
    private RepositoryRecrutador repositoryRecrutador;

    @Transactional
    @Generated
    public EntityRecrutador criarRecrutador(EntityRecrutador recrutador) {

        EntityRecrutador novoRecrutador = repositoryRecrutador.save(recrutador);

        if (novoRecrutador.getRecrutadorAdminId() != null) {
            EntityAdministrador administrador = repositoryAdministrador.findById(novoRecrutador.getRecrutadorAdminId())
                    .orElseThrow(() -> new ExeptionNaoEncontrado("Administrador não encontrado " + novoRecrutador.getRecrutadorAdminId()));

            administrador.getAdminRecrutadores().add(novoRecrutador);
            repositoryAdministrador.save(administrador);
        }

        return novoRecrutador;
    }

    public void removerRecrutador(String recrutadorId) {
        repositoryRecrutador.deleteById(recrutadorId);
    }


    public List<EntityRecrutador> listarRecrutadores(String administradorId) {
        EntityAdministrador administrador = repositoryAdministrador.findById(administradorId)
                .orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.ADM_NAO_ENCONTRADO));

        return administrador.getAdminRecrutadores();
    }

    public EntityRecrutador buscarRecrut(String id){
        EntityRecrutador recrutador = repositoryRecrutador.findById(id)
                .orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.REC_NAO_ENCONTRADO));
        return recrutador;
    }


    public Optional<String> buscarAdminIdPorRecrutadorId(String recrutadorId) {
        return repositoryRecrutador.findById(recrutadorId)
                .map(EntityRecrutador::getRecrutadorAdminId);
    }
  
    public EntityRecrutador alterarRecrutador(String id, RecrutadorDTO dto){
        EntityRecrutador recrutador = repositoryRecrutador.findById(id)
                .orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.REC_NAO_ENCONTRADO));
        recrutador.setEmail(dto.getRecrutadoEmailDto());
        recrutador.setTelefone(dto.getRecrutadoTelefoneDto());
        recrutador.setNome(dto.getRecrutadorNomeDto());
        repositoryRecrutador.save(recrutador);
        return recrutador;

    }

    public EntityRecrutador infoRec(String recId){
        return repositoryRecrutador.findById(recId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.REC_NAO_ENCONTRADO));
    }

    public void alterarEmail(String email,String recId){
        EntityRecrutador rec = repositoryRecrutador.findById(recId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.REC_NAO_ENCONTRADO));
        rec.setEmail(email);
        repositoryRecrutador.save(rec);
    }

    public void alterarSenha(String senha,String recId){
        EntityRecrutador rec = repositoryRecrutador.findById(recId).orElseThrow(()-> new ExeptionNaoEncontrado(ExeceptionsMensage.REC_NAO_ENCONTRADO));
        rec.setSenha(senha);
        repositoryRecrutador.save(rec);
    }
}

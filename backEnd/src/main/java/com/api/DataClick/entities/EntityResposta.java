package com.api.DataClick.entities;

import com.api.DataClick.enums.TipoCampo;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;

@Getter
public class EntityResposta {

    @Setter
    private TipoCampo tipo;
    private Object resposta;

}
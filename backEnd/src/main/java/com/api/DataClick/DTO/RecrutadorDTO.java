package com.api.DataClick.DTO;


import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class RecrutadorDTO {

    private String recrutadorNomeDto;
    private String recrutadoTelefoneDto;
    private String recrutadoEmailDto;
    private String recrutadorSenhaDto;

    public String getRecrutadorNomeDto() {
        return recrutadorNomeDto;
    }

    public String getRecrutadoTelefoneDto() {
        return recrutadoTelefoneDto;
    }

    public String getRecrutadoEmailDto() {
        return recrutadoEmailDto;
    }

    public String getRecrutadorSenhaDto() {
        return recrutadorSenhaDto;
    }

    public void setRecrutadorNomeDto(String recrutadorNomeDto) {
        this.recrutadorNomeDto = recrutadorNomeDto;
    }

    public void setRecrutadoTelefoneDto(String recrutadoTelefoneDto) {
        this.recrutadoTelefoneDto = recrutadoTelefoneDto;
    }

    public void setRecrutadoEmailDto(String recrutadoEmailDto) {
        this.recrutadoEmailDto = recrutadoEmailDto;
    }

    public void setRecrutadorSenhaDto(String recrutadorSenhaDto) {
        this.recrutadorSenhaDto = recrutadorSenhaDto;
    }
}

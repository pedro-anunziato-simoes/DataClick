package com.api.DataClick.DTO;

import com.api.DataClick.validations.Telefone;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import org.hibernate.validator.constraints.br.CNPJ;

public record RegisterAdminDTO(
        @NotBlank(message = "Nome é obrigatório")
        String nome,
        @NotBlank(message = "Email é obrigatório")
        @Email(message = "Email inválido")
        String email,
        @NotBlank(message = "Senha é obrigatória")
        String senha,
        @NotBlank(message = "Telefone é obrigatório")
        @Telefone(message = "Telefone inválido")
        String telefone,
        @NotBlank(message = "CNPJ é obrigatório")
        @CNPJ(message = "CNPJ inválido")
        String cnpj)  {
}

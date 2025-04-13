package com.api.DataClick.DTO;

public record RegisterAdminDTO(
        String nome,
        String email,
        String senha,
        String telefone,
        String cnpj) {
}

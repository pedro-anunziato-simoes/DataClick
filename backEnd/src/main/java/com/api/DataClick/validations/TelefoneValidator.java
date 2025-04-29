package com.api.DataClick.validations;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

import java.util.regex.Pattern;

public class TelefoneValidator implements ConstraintValidator<Telefone, String> {

    private static final Pattern TELEFONE_PATTERN = Pattern.compile(
            "^(\\(?\\d{2}\\)?)?\\s?(9?\\d{4}[-. ]?\\d{4})$"
    );

    @Override
    public boolean isValid(String telefone, ConstraintValidatorContext context) {
        if (telefone == null) return false;

        String cleaned = telefone.replaceAll("[^\\d]", "");

        return cleaned.matches("^(55)?\\d{10,11}$") && TELEFONE_PATTERN.matcher(telefone).matches();
    }
}

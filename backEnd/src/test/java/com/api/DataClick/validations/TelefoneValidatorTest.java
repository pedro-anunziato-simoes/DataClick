package com.api.DataClick.validations;

import com.api.DataClick.validations.Telefone;
import com.api.DataClick.validations.TelefoneValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.mockito.Mock;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.mock;

public class TelefoneValidatorTest {

    private TelefoneValidator validator;
    @Mock
    private ConstraintValidatorContext context;

    @BeforeEach
    void setUp() {
        validator = new TelefoneValidator();
        context = mock(ConstraintValidatorContext.class);
    }

    @ParameterizedTest
    @ValueSource(strings = {
            "(11) 91234-5678",
            "11 912345678",
            "11912345678",
            "91234-5678",
            "912345678",
            "5511912345678",
            "55(11)91234-5678",
            "1234-5678", // Fixo com 8 dígitos
            "(11) 1234-5678"
    })
    void isValid_DeveRetornarTrue_ParaTelefonesValidos(String telefone) {
        assertTrue(validator.isValid(telefone, context));
    }

    @ParameterizedTest
    @ValueSource(strings = {
            "12345",
            "ABCDE12345",
            "(11) 9123-456",
            "11 91234 5678",
            "+55 11 91234-5678",
            "(11) 9 1234-5678",
            "123456789012"
    })
    void isValid_DeveRetornarFalse_ParaTelefonesInvalidos(String telefone) {
        assertFalse(validator.isValid(telefone, context));
    }

    @Test
    void isValid_DeveRetornarFalse_ParaValorNulo() {
        assertFalse(validator.isValid(null, context));
    }

    @Test
    void isValid_DeveLidarComFormatosNaoConvencionais() {
        assertAll(
                () -> assertTrue(validator.isValid("11 91234.5678", context)),
                () -> assertTrue(validator.isValid("11 91234567", context)),
                () -> assertFalse(validator.isValid("(11)9A123-4567", context))
        );
    }
}

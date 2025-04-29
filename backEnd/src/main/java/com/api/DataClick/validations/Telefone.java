package com.api.DataClick.validations;


import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import org.springframework.data.mongodb.core.mapping.Document;

import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = TelefoneValidator.class)
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface Telefone {
    String message() default "Telefone inválido";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};

}

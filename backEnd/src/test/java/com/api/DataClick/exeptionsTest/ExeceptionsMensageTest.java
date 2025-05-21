package com.api.DataClick.exeptionsTest;


import com.api.DataClick.exeptions.ExeceptionsMensage;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class ExeceptionsMensageTest {
    @Test
    void construtor_DeveSerAcessivelSemErros() {
        ExeceptionsMensage mensagens = new ExeceptionsMensage();

        assertNotNull(mensagens, "A instância deve ser criada com sucesso");
    }
}

package com.api.DataClick.Config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")  // Permita todas as origens durante desenvolvimento
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")  // Adicionei OPTIONS
                .allowedHeaders("*")
                .exposedHeaders("*")  // Expõe todos os cabeçalhos
                .allowCredentials(false)
                .maxAge(3600);
    }
}
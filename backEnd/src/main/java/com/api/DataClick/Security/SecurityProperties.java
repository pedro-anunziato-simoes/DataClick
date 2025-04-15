package com.api.DataClick.Security;

import lombok.Getter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Getter
@Component
@ConfigurationProperties(prefix = "security")
public class SecurityProperties {

    private String SECRET_KEY;

}

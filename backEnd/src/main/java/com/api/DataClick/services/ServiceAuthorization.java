package com.api.DataClick.services;


import com.api.DataClick.repositories.RepositoryAdministrador;
import com.api.DataClick.repositories.RepositoryRecrutador;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class ServiceAuthorization implements UserDetailsService {

    @Autowired
    RepositoryRecrutador recrutador;

    @Autowired
    RepositoryAdministrador administrador;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        UserDetails user = administrador.findByEmail(username);
        if (user == null) {
            user = recrutador.findByEmail(username);
        }

        if (user == null) {
            throw new UsernameNotFoundException("Usuário não encontrado: " + username);
        }

        System.out.println("Authorities do usuário: " + user.getAuthorities());
        return user;
    }
}

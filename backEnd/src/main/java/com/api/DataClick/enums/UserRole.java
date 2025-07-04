package com.api.DataClick.enums;


public enum UserRole {

    ADMIN("ROLE_ADMIN"),
    USER("ROLE_USER"),
    INVALID("ROLE_INVALID");

    private String role;

    UserRole(String role){
        this.role = role;
    }

    public String getRole() {
        return role;
    }
}

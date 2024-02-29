

package com.haatbazar.backend.User.dto.user;

public class SignInResponseDto {
    private String status;
    private String token;
    private String role;

    public String getStatus() {
        return this.status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getToken() {
        return this.token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getRole() {
        return this.role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public SignInResponseDto(String status, String token, String role) {
        this.status = status;
        this.token = token;
        this.role = role;
    }
}

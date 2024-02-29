

package com.haatbazar.backend.User.dto.user;

public class VerifyDto {
    private String otp;
    private String email;

    public VerifyDto() {
    }

    public String getOtp() {
        return this.otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public String getEmail() {
        return this.email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}

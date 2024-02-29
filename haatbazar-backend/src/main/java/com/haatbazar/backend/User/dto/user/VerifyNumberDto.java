package com.haatbazar.backend.User.dto.user;

public class VerifyNumberDto{
    private String number;
    private String otp;
    private String email;
    public VerifyNumberDto(){}

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}

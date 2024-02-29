

package com.haatbazar.backend.User.dto.user;

public class ResponseDto {
    private String status;
    private String message;

    public String getStatus() {
        return this.status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMessage() {
        return this.message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public ResponseDto(String status, String message) {
        this.status = status;
        this.message = message;
    }
}

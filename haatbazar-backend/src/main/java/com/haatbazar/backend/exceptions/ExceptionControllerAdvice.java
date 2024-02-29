package com.haatbazar.backend.exceptions;

import com.haatbazar.backend.exceptions.AuthenticationFailException;
import com.haatbazar.backend.exceptions.CustomException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class ExceptionControllerAdvice {

    @ExceptionHandler({CustomException.class})
    @ResponseBody
    public final ResponseEntity<Map<String, String>> handleCustomException(CustomException exception) {
        Map<String, String> responseBody = new HashMap<>();
        responseBody.put("message", exception.getMessage());
        return new ResponseEntity<>(responseBody, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler({AuthenticationFailException.class})
    @ResponseBody
    public final ResponseEntity<Map<String, String>> handleAuthenticationFailException(AuthenticationFailException exception) {
        Map<String, String> responseBody = new HashMap<>();
        responseBody.put("message", exception.getMessage());
        return new ResponseEntity<>(responseBody, HttpStatus.UNAUTHORIZED);
    }
}

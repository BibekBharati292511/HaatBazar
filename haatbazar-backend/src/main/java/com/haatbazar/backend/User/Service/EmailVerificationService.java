
package com.haatbazar.backend.User.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailVerificationService {
    private static final Logger logger = LoggerFactory.getLogger(EmailVerificationService.class);
    private final JavaMailSender javaMailSender;
    private final Map<String, Long> otpMap = new HashMap();

    @Autowired
    public EmailVerificationService(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

    public boolean sendVerificationEmail(String email) {
        try {
            String otp = this.generateOTP();
            long expirationTime = System.currentTimeMillis() + 600000L;
            this.otpMap.put(otp, expirationTime);
            SimpleMailMessage mailMessage = new SimpleMailMessage();
            mailMessage.setTo(email);
            mailMessage.setSubject("Email Verification");
            mailMessage.setText("Your verification code is: " + otp);
            this.javaMailSender.send(mailMessage);
            logger.info("Verification email sent to: {}", email);
            return true;
        } catch (Exception var6) {
            logger.error("Failed to send verification email to: {}", email, var6);
            return false;
        }
    }

    public boolean verifyEmail(String email, String enteredOTP) {
        if (this.otpMap.containsKey(enteredOTP) && (Long)this.otpMap.get(enteredOTP) >= System.currentTimeMillis()) {
            this.otpMap.remove(enteredOTP);
            return true;
        } else {
            return false;
        }
    }

    private String generateOTP() {
        Random random = new Random();
        int otpNumber = 100000 + random.nextInt(900000);
        return String.valueOf(otpNumber);
    }
}

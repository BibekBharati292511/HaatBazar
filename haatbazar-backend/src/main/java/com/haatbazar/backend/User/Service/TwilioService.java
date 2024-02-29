package com.haatbazar.backend.User.Service;

import com.haatbazar.backend.User.Model.User;
import com.haatbazar.backend.User.Repository.TokenRepository;
import com.haatbazar.backend.User.Repository.UserRepository;
import com.haatbazar.backend.User.dto.user.ResponseDto;
import com.haatbazar.backend.User.dto.user.VerifyNumberDto;
import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Random;

@Service
public class TwilioService {
    @Autowired
    UserRepository userRepository;
    @Autowired
    TokenRepository tokenRepository;

    @Value("${twilio.accountSid}")
    private String accountSid;

    @Value("${twilio.authToken}")
    private String authToken;

    // Define the sender's phone number
    private final String senderPhoneNumber = "+15166898900";

    // HashMap to store temporary OTPs with corresponding phone numbers
    private final Map<String, String> otpMap = new HashMap<>();

    public void sendSms(String to) {
        // Generate OTP and message body dynamically
        String otp = generateOTP();
        otpMap.put(to,otp);
        String messageBody = "The otp for your number verification is " + otp + " If this message is sent to you unintentionally. Please, kindly ignore";

        Twilio.init(accountSid, authToken);
        Message message = Message.creator(
                        new PhoneNumber(to),
                        new PhoneNumber(senderPhoneNumber),
                        messageBody)
                .create();
        System.out.println("Message sent. SID: " + message.getSid());
    }


    public ResponseDto verifyNumberOtp(VerifyNumberDto verifyNumberDto){
        String phoneNumber = verifyNumberDto.getNumber();
        String enteredOtp = verifyNumberDto.getOtp();
        // Retrieve OTP from HashMap
        String storedOtp = otpMap.get(phoneNumber);
        if (!Objects.nonNull(this.userRepository.findByEmail(verifyNumberDto.getEmail()))) {
            System.out.println(verifyNumberDto.getEmail());
            return new ResponseDto("Error", "Cannot update phone number for now");

        } else {
            // If the token is found, proceed to OTP verification
            if (storedOtp != null && storedOtp.equals(enteredOtp)) {
                User user = this.userRepository.findByEmail(verifyNumberDto.getEmail());
                user.setPhone_number(phoneNumber);
                this.userRepository.save(user);
                return new ResponseDto("Success", "Number registered successfully");
            } else {
                return new ResponseDto("Error", "Invalid OTP or OTP expired");
            }
        }

    }

    private String generateOTP() {
        Random random = new Random();
        int otpNumber = 100000 + random.nextInt(900000);
        return String.valueOf(otpNumber);
    }
}

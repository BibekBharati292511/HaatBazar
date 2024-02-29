

package com.haatbazar.backend.User.Controller;

import com.haatbazar.backend.User.Model.AuthenticationToken;
import com.haatbazar.backend.User.Model.SmsRequest;
import com.haatbazar.backend.User.Model.User;
import com.haatbazar.backend.User.Model.UserRole;
import com.haatbazar.backend.User.Repository.TokenRepository;
import com.haatbazar.backend.User.Service.TwilioService;
import com.haatbazar.backend.User.Service.UserRoleService;
import com.haatbazar.backend.User.Service.UserService;
import com.haatbazar.backend.User.Service.VerifyService;
import com.haatbazar.backend.User.dto.user.*;
import com.haatbazar.backend.exceptions.AuthenticationFailException;
import com.haatbazar.backend.exceptions.CustomException;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequestMapping({"user"})
@RestController
public class UserController {
    @Autowired
    UserService userService;
    @Autowired
    VerifyService verifyService;
    @Autowired
    UserRoleService userRoleService;
    @Autowired
    TokenRepository tokenRepository;

    public UserController() {
    }

    @PostMapping({"/setUserRole"})
    public ResponseDto setUserRole(@RequestBody UserRoleDto userRoleDto) throws CustomException {
        return this.userRoleService.userRole(userRoleDto);
    }

    @GetMapping({"/getUserRole"})
    public List<UserRole> getUserRoles() throws CustomException {
        return this.userRoleService.getAllUserRoles();
    }

    @PostMapping({"/signup"})
    public SignUpResponseDto Signup(@RequestBody SignupDto signupDto) throws CustomException, CustomException {
        return this.userService.signUp(signupDto);
    }

    @PostMapping({"/verify"})
    public SignUpResponseDto verify(@RequestBody VerifyDto verifyDto) throws CustomException {
        return this.verifyService.verify(verifyDto);
    }

    @PostMapping({"/sendPassResetOtp"})
    public ResponseDto sendPassResetOtp(@RequestBody UpdateDto updateDto) throws CustomException {
        try {
            return this.userService.update(updateDto);
        } catch (CustomException var3) {
            return new ResponseDto("error", var3.getMessage());
        }
    }

    @PostMapping({"/verifyResetOtp"})
    public ResponseDto verifyResetOtp(@RequestBody VerifyDto verifyDto) throws CustomException {
        try {
            return this.verifyService.updateUser(verifyDto);
        } catch (CustomException var3) {
            return new ResponseDto("error", var3.getMessage());
        }
    }

    @PostMapping({"/signIn"})
    public SignInResponseDto Signup(@RequestBody SignInDto signInDto) throws CustomException, AuthenticationFailException, AuthenticationFailException {
        return this.userService.signIn(signInDto);
    }

    @DeleteMapping({"/deleteUser"})
    public ResponseDto removeUser(@RequestBody DeleteDto deleteDto) throws CustomException {
        return this.userService.deleteUser(deleteDto);
    }

    @PutMapping({"/changePassword"})
    public ResponseDto changePassword(@RequestBody ChangePassDto changePassDto) {
        try {
            return this.userService.passwordChange(changePassDto);
        } catch (CustomException var3) {
            return new ResponseDto("error", var3.getMessage());
        }
    }

    @Autowired
    private TwilioService twilioService;

    @PostMapping("/sendSms")
    public void sendSms(@RequestBody SmsRequest smsRequest) {
        // Generate OTP and set the body
        twilioService.sendSms(smsRequest.getTo()); // Send SMS with generated OTP
    }
    @PostMapping({"/verifyNumberOtp"})
    public ResponseDto verifyNumber(@RequestBody VerifyNumberDto verifyNumberDto) throws CustomException, CustomException {
        return this.twilioService.verifyNumberOtp(verifyNumberDto);
    }
    @GetMapping("/getUsers")
    public ResponseEntity<?> getUserByToken(@RequestHeader("Authorization") String token) {
        AuthenticationToken authenticationToken = tokenRepository.findTokenByToken(token);
        if (authenticationToken == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        User user = authenticationToken.getUser();
        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        return ResponseEntity.ok(user);
    }
    @PutMapping({"/changeUserInfo"})
    public ResponseDto changeUserInfo(@RequestBody User user) {
        return this.userService.updateUserInformation(user);
    }
    @PostMapping({"/checkProfileStats"})
    public ResponseDto checkProfileStatus(@RequestBody  User user){
        return this.userService.checkProfileCompleted(user);
    }




}

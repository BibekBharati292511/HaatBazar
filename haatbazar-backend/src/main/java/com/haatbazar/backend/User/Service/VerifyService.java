//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package com.haatbazar.backend.User.Service;

import com.haatbazar.backend.User.Model.AuthenticationToken;
import com.haatbazar.backend.User.Model.User;
import com.haatbazar.backend.User.Model.UserRole;
import com.haatbazar.backend.User.Repository.TokenRepository;
import com.haatbazar.backend.User.Repository.UserRepository;
import com.haatbazar.backend.User.Repository.UserRoleRepository;
import com.haatbazar.backend.User.dto.user.ResponseDto;
import com.haatbazar.backend.User.dto.user.SignUpResponseDto;
import com.haatbazar.backend.User.dto.user.VerifyDto;
import com.haatbazar.backend.exceptions.CustomException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class VerifyService {
    private final EmailVerificationService emailVerificationService;
    @Autowired
    private final UserRepository userRepository;
    @Autowired
    private final TokenRepository tokenRepository;
    @Autowired
    UserRoleRepository userRoleRepository;
    @Autowired
    private final UserService userService;
    @Autowired
    AuthenticationService authenticationService;

    public VerifyService(EmailVerificationService emailVerificationService, UserRepository userRepository, UserService userService, TokenRepository tokenRepository) {
        this.emailVerificationService = emailVerificationService;
        this.userRepository = userRepository;
        this.userService = userService;
        this.tokenRepository = tokenRepository;
    }

    public SignUpResponseDto verify(VerifyDto verifyDto) throws CustomException {
        Integer roleId = (Integer)this.userService.verificationData.get(4);
        UserRole userRole = (UserRole)this.userRoleRepository.findById(roleId).orElseThrow(() -> {
            return new CustomException("UserRole not found with id: " + roleId);
        });
        boolean isVerified = this.emailVerificationService.verifyEmail(verifyDto.getEmail(), verifyDto.getOtp());
        if (isVerified) {
            User user = new User(this.userService.verificationData.get(2), this.userService.verificationData.get(3), this.userService.verificationData.get(0), this.userService.verificationData.get(1), userRole);

            try {
                this.userRepository.save(user);
                AuthenticationToken authenticationToken = new AuthenticationToken(user);
                this.authenticationService.saveConfirmationToken(authenticationToken);
                String var10003 = String.valueOf(this.userService.verificationData.get(0));
                return new SignUpResponseDto("success", "user created successfully" + var10003 + String.valueOf(this.userService.verificationData.get(1)) + String.valueOf(this.userService.verificationData.get(2)) + String.valueOf(this.userService.verificationData.get(3)));
            } catch (Exception var7) {
                throw new CustomException(var7.getMessage());
            }
        } else {
            return new SignUpResponseDto("error", "Invalid verification code. Please try again.");
        }
    }

    public ResponseDto updateUser(VerifyDto verifyDto) throws CustomException {
        boolean isVerified = this.emailVerificationService.verifyEmail(verifyDto.getEmail(), verifyDto.getOtp());
        return isVerified ? new ResponseDto("success", "Otp verified") : new ResponseDto("Error", "Invalid verification code. Please try again.");
    }
}

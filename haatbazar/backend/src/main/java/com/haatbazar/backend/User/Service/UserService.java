
package com.haatbazar.backend.User.Service;

import com.haatbazar.backend.Configuration.MessageStrings;
import com.haatbazar.backend.User.Model.AuthenticationToken;
import com.haatbazar.backend.User.Model.User;
import com.haatbazar.backend.User.Model.UserRole;
import com.haatbazar.backend.User.Repository.TokenRepository;
import com.haatbazar.backend.User.Repository.UserRepository;
import com.haatbazar.backend.User.dto.user.ChangePassDto;
import com.haatbazar.backend.User.dto.user.DeleteDto;
import com.haatbazar.backend.User.dto.user.ResponseDto;
import com.haatbazar.backend.User.dto.user.SignInDto;
import com.haatbazar.backend.User.dto.user.SignInResponseDto;
import com.haatbazar.backend.User.dto.user.SignUpResponseDto;
import com.haatbazar.backend.User.dto.user.SignupDto;
import com.haatbazar.backend.User.dto.user.UpdateDto;
import com.haatbazar.backend.exceptions.AuthenticationFailException;
import com.haatbazar.backend.exceptions.CustomException;
import jakarta.xml.bind.DatatypeConverter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    private final EmailVerificationService emailVerificationService;
    public List<Object> verificationData = new ArrayList(5);
    @Autowired
    UserRepository userRepository;
    @Autowired
    AuthenticationService authenticationService;
    @Autowired
    TokenRepository tokenRepository;
    Logger logger = LoggerFactory.getLogger(UserService.class);

    @Autowired
    public UserService(EmailVerificationService emailVerificationService) {
        this.emailVerificationService = emailVerificationService;
    }

    public ResponseDto update(UpdateDto updateDto) throws CustomException {
        if (!Objects.nonNull(this.userRepository.findByEmail(updateDto.getEmail()))) {
            return new ResponseDto("Error", "User doesnt exist");
        } else {
            String email = updateDto.getEmail();
            boolean emailSent = this.emailVerificationService.sendVerificationEmail(email);
            return emailSent ? new ResponseDto("Sucess", "email verification is pending,check your email") : new ResponseDto("Error", "Failed to send verification email");
        }
    }


    public ResponseDto passwordChange(ChangePassDto changePassDto) throws CustomException {
        User user = this.userRepository.findByEmail(changePassDto.getEmail());
        String newEncryptedPassword = changePassDto.getNewPassword();

        try {
            newEncryptedPassword = this.hashPassword(changePassDto.getNewPassword());
            System.out.println("Encoded pass is " + newEncryptedPassword);
        } catch (NoSuchAlgorithmException var5) {
            var5.printStackTrace();
            this.logger.error("hashing password failed {}", var5.getMessage());
        }

        user.setPassword(newEncryptedPassword);
        this.userRepository.save(user);
        return new ResponseDto("success", "Password reset successfully");
    }

    public SignUpResponseDto signUp(SignupDto signupDto) throws CustomException {
        if (Objects.nonNull(this.userRepository.findByEmail(signupDto.getEmail()))) {
            return new SignUpResponseDto("Error", "user already exists");
        } else {
            String encryptedPassword = signupDto.getPassword();

            try {
                encryptedPassword = this.hashPassword(signupDto.getPassword());
            } catch (NoSuchAlgorithmException var5) {
                var5.printStackTrace();
                this.logger.error("hashing password failed {}", var5.getMessage());
            }

            String email = signupDto.getEmail();
            boolean emailSent = this.emailVerificationService.sendVerificationEmail(email);
            if (emailSent) {
                this.verificationData.add(signupDto.getEmail());
                this.verificationData.add(encryptedPassword);
                this.verificationData.add(signupDto.getFirstName());
                this.verificationData.add(signupDto.getLastName());
                this.verificationData.add(signupDto.getRoleId());
                return new SignUpResponseDto("sucess", "email verification is pending,check your email");
            } else {
                return new SignUpResponseDto("error", "Failed to send verification email");
            }
        }
    }

    String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(password.getBytes());
        byte[] digest = md.digest();
        String myHash = DatatypeConverter.printHexBinary(digest).toUpperCase();
        return myHash;
    }

    public SignInResponseDto signIn(SignInDto signInDto) throws AuthenticationFailException, CustomException {
        User user = this.userRepository.findByEmail(signInDto.getEmail());
        if (!Objects.nonNull(user)) {
            throw new AuthenticationFailException(MessageStrings.User_Not_Present);
        } else {
            try {
                if (!user.getPassword().equals(this.hashPassword(signInDto.getPassword()))) {
                    throw new AuthenticationFailException(MessageStrings.WRONG_PASSWORD);
                }
            } catch (NoSuchAlgorithmException var5) {
                var5.printStackTrace();
                this.logger.error("hashing password failed {}", var5.getMessage());
                throw new CustomException(var5.getMessage());
            }

            UserRole userRole = user.getRole();
            AuthenticationToken token = this.authenticationService.getToken(user);
            if (!Objects.nonNull(token)) {
                throw new CustomException(MessageStrings.AUTH_TOEKN_NOT_PRESENT);
            } else {
                return new SignInResponseDto("success", token.getToken(), userRole.getRole());
            }
        }
    }

    public ResponseDto deleteUser(DeleteDto deleteDto) throws CustomException {
        User user = this.userRepository.findByEmail(deleteDto.getEmail());
        if (user == null) {
            throw new CustomException("User not found with email: " + deleteDto.getEmail());
        } else {
            AuthenticationToken token = this.tokenRepository.findTokenByUser(user);
            if (token != null) {
                this.tokenRepository.delete(token);
                this.logger.info("Token deleted successfully for user with email: " + deleteDto.getEmail());
            }

            this.userRepository.delete(user);
            this.logger.info("User deleted successfully with email: " + deleteDto.getEmail());
            return new ResponseDto("success", "User deleted successfully");
        }
    }
    public ResponseDto updateUserInformation(User user) {
        try {
            User existingUser = userRepository.findByEmail(user.getEmail());

            if (existingUser == null) {
                return new ResponseDto("Error", "User doesn't exist");
            }

            if (user.getNewPassword() != null) {
                // Retrieve the stored password from the database
                String storedPassword = existingUser.getPassword();
                String hashedOldPassword = this.hashPassword(user.getPassword());

                // Hash the new password
                String hashedNewPassword = this.hashPassword(user.getNewPassword());

                // Compare old password with the stored password
                if (storedPassword.equals(hashedOldPassword)) {
                    existingUser.setPassword(hashedNewPassword);
                    userRepository.save(existingUser);
                    return new ResponseDto("Success", "Password changed");
                } else {
                    return new ResponseDto("Error", "Password did not match");
                }
            }
            // Update first name if provided
            if (user.getFirstName() != null) {
                existingUser.setFirstName(user.getFirstName());
            }

            // Update last name if provided
            if (user.getLastName() != null) {
                existingUser.setLastName(user.getLastName());
            }
            if(user.getImage()!=null){
                existingUser.setImage(user.getImage());
            }

            // Save the updated user information
            userRepository.save(existingUser);


            return new ResponseDto("Success", "User information updated successfully");
        } catch (Exception e) {
            logger.error("Error updating user information: {}", e.getMessage());
            return new ResponseDto("Error", "Failed to update user information: " + e.getMessage());
        }
    }
    public ResponseDto checkProfileCompleted(User user){
        try{
            User existingUser = userRepository.findByEmail(user.getEmail());

            if (existingUser == null) {
                return new ResponseDto("Error", "User doesn't exist");
            }
            if(existingUser.getFirstName()!=null && existingUser.getLastName()!=null && existingUser.getImage()!=null && existingUser.getPhone_number()!=null){
                return new ResponseDto("Success","No fields are empty");
            }
            else {
                return new ResponseDto("Error","Profile not completed yet");
            }
        }
        catch (Exception e){
            logger.error("Error getting profile information: {}", e.getMessage());
            return new ResponseDto("Error", "Failed to get user status " + e.getMessage());
        }
    }



}

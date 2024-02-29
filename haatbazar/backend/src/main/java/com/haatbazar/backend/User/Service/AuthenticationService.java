//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package com.haatbazar.backend.User.Service;

import com.haatbazar.backend.User.Model.AuthenticationToken;
import com.haatbazar.backend.User.Model.User;
import com.haatbazar.backend.User.Repository.TokenRepository;
import com.haatbazar.backend.exceptions.AuthenticationFailException;
import java.util.Objects;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AuthenticationService {
    @Autowired
    TokenRepository repository;

    public AuthenticationService() {
    }

    public void saveConfirmationToken(AuthenticationToken authenticationToken) {
        this.repository.save(authenticationToken);
    }

    public AuthenticationToken getToken(User user) {
        return this.repository.findTokenByUser(user);
    }

    public User getUser(String token) {
        AuthenticationToken authenticationToken = this.repository.findTokenByToken(token);
        return Objects.nonNull(authenticationToken) && Objects.nonNull(authenticationToken.getUser()) ? authenticationToken.getUser() : null;
    }

    public void authenticate(String token) throws AuthenticationFailException {
        if (!Objects.nonNull(token)) {
            throw new AuthenticationFailException("authentication token not present");
        } else if (!Objects.nonNull(this.getUser(token))) {
            throw new AuthenticationFailException("authentication token not valid");
        }
    }
}

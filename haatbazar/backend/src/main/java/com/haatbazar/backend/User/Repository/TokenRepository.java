
package com.haatbazar.backend.User.Repository;

import com.haatbazar.backend.Store.Model.Store;
import com.haatbazar.backend.User.Model.AuthenticationToken;
import com.haatbazar.backend.User.Model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TokenRepository extends JpaRepository<AuthenticationToken, Integer> {
    AuthenticationToken findTokenByUser(User user);


    AuthenticationToken findTokenByToken(String token);
}

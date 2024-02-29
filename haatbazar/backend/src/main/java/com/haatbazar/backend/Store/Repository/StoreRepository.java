package com.haatbazar.backend.Store.Repository;

import com.haatbazar.backend.Store.Model.Store;
import com.haatbazar.backend.Store.Model.StoreType;
import com.haatbazar.backend.User.Model.AuthenticationToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StoreRepository extends JpaRepository<Store,AuthenticationToken> {
    boolean existsByToken(String token);

    Store findByToken(String token);
    Store findBStoreByType(StoreType type);
}

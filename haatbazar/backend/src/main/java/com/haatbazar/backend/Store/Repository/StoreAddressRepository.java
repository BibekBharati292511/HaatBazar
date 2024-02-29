package com.haatbazar.backend.Store.Repository;

import com.haatbazar.backend.Store.Model.StoreAddress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface StoreAddressRepository extends JpaRepository<StoreAddress, Integer> {

    // Address findByEmail(String email);

     Optional<StoreAddress> findByStoreId(int storeId);
}
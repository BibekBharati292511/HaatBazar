package com.haatbazar.backend.User.Repository;

import com.haatbazar.backend.User.Model.Address;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;


@Repository
public interface AddressRepository extends JpaRepository<Address, Integer> {

   // Address findByEmail(String email);

    Optional<Address> findByUserId(int userId);
}

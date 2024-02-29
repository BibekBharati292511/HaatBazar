package com.haatbazar.backend.Store.Repository;

import com.haatbazar.backend.Store.Model.DeliveryOptions;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DeliveryOptionsRepository extends JpaRepository<DeliveryOptions, Integer> {
    DeliveryOptions findByDeliveryOptions(String deliveryOptions);
}

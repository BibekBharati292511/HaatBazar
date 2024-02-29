package com.haatbazar.backend.Store.Repository;

import com.haatbazar.backend.Store.Dto.StoreDto;
import com.haatbazar.backend.Store.Model.DeliveryOptions;
import com.haatbazar.backend.Store.Model.Store;
import com.haatbazar.backend.Store.Model.StoreDeliveryOptions;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StoreDeliveryOptionsRepository extends JpaRepository<StoreDeliveryOptions,Integer> {
    StoreDeliveryOptions findByStore(Store store);

    StoreDeliveryOptions findByDeliveryOption(DeliveryOptions deliveryOptions);
}

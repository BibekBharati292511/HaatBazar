package com.haatbazar.backend.Store.Service;

import com.haatbazar.backend.Store.Dto.DeliveryOptionsDto;
import com.haatbazar.backend.Store.Dto.StoreDeliveryOptionsDto;
import com.haatbazar.backend.Store.Model.DeliveryOptions;
import com.haatbazar.backend.Store.Model.Store;
import com.haatbazar.backend.Store.Model.StoreDeliveryOptions;
import com.haatbazar.backend.Store.Repository.DeliveryOptionsRepository;
import com.haatbazar.backend.Store.Repository.StoreDeliveryOptionsRepository;
import com.haatbazar.backend.Store.Repository.StoreRepository;
import com.haatbazar.backend.User.Model.User;
import com.haatbazar.backend.User.dto.user.ResponseDto;
import com.haatbazar.backend.exceptions.CustomException;
import org.springframework.stereotype.Service;

import java.util.Objects;

@Service
public class StoreDeliveryOptionsService {
    private final StoreDeliveryOptionsRepository storeDeliveryOptionsRepository;
    private final StoreRepository storeRepository;
    private final DeliveryOptionsRepository deliveryOptionsRepository;
    public StoreDeliveryOptionsService(StoreDeliveryOptionsRepository storeDeliveryOptionsRepository,StoreRepository storeRepository,DeliveryOptionsRepository deliveryOptionsRepository){
        this.storeDeliveryOptionsRepository=storeDeliveryOptionsRepository;
        this.storeRepository=storeRepository;
        this.deliveryOptionsRepository=deliveryOptionsRepository;
    }
    public ResponseDto StoreDeliveryOptions(StoreDeliveryOptionsDto storeDeliveryOptionsDto) throws CustomException {
        //Find store and delivery options and validate
        Store store = this.storeRepository.findByToken(storeDeliveryOptionsDto.getToken());
        DeliveryOptions deliveryOptions=deliveryOptionsRepository.findByDeliveryOptions(storeDeliveryOptionsDto.getDeliveryOption());
        if (store == null) {
            throw new CustomException("Store not found");
        }

        if (deliveryOptions == null) {
            throw new CustomException("Delivery options not found");
        }

        // Check if the store delivery options already exist and validate
        StoreDeliveryOptions existingDeliveryOptions=this.storeDeliveryOptionsRepository.findByDeliveryOption(deliveryOptions);
        StoreDeliveryOptions existingStore=this.storeDeliveryOptionsRepository.findByStore(store);
        if (Objects.nonNull(existingStore) && Objects.nonNull(existingDeliveryOptions) ) {
            throw new CustomException("Store Delivery Option already exist");
        } else {
            StoreDeliveryOptions newDeliveryOptions = new StoreDeliveryOptions();
            newDeliveryOptions.setStore(store);
            newDeliveryOptions.setDeliveryOption(deliveryOptions);
            this.storeDeliveryOptionsRepository.save(newDeliveryOptions);
            return new ResponseDto("success", "New Store Delivery Option created");
        }
    }
}

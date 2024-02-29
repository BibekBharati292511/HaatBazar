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

import java.util.ArrayList;
import java.util.List;
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
    public ResponseDto storeDeliveryOptions(StoreDeliveryOptionsDto storeDeliveryOptionsDto) throws CustomException {
        // Find store and validate
        Store store = this.storeRepository.findByToken(storeDeliveryOptionsDto.getToken());
        if (store == null) {
            throw new CustomException("Store not found");
        }

        List<StoreDeliveryOptions> newDeliveryOptionsList = new ArrayList<>();
        for (String deliveryOption : storeDeliveryOptionsDto.getDeliveryOptions()) {
            // Find delivery option and validate
            DeliveryOptions deliveryOptions = deliveryOptionsRepository.findByDeliveryOptions(deliveryOption);
            if (deliveryOptions == null) {
                throw new CustomException("Delivery option '" + deliveryOption + "' not found");
            }

            // Check if the store delivery options already exist and validate
            StoreDeliveryOptions existingDeliveryOptions = this.storeDeliveryOptionsRepository.findByDeliveryOption(deliveryOptions);
            if (existingDeliveryOptions != null) {
                throw new CustomException("Store Delivery Option '" + deliveryOption + "' already exists");
            } else {
                StoreDeliveryOptions newDeliveryOptions = new StoreDeliveryOptions();
                newDeliveryOptions.setStore(store);
                newDeliveryOptions.setDeliveryOption(deliveryOptions);
                newDeliveryOptionsList.add(newDeliveryOptions);
            }
        }

        // Save all new store delivery options
        this.storeDeliveryOptionsRepository.saveAll(newDeliveryOptionsList);

        return new ResponseDto("success", "New Store Delivery Options created");
    }
    public ResponseDto getstoreDeliveryOptions(StoreDeliveryOptionsDto storeDeliveryOptionsDto) throws CustomException {
        // Find store and validate
        Store store = this.storeRepository.findByToken(storeDeliveryOptionsDto.getToken());
        if (store == null) {
            throw new CustomException("Store not found");
        }
        return new ResponseDto("ds","");
    }

}

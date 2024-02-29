package com.haatbazar.backend.Store.Service;

import com.haatbazar.backend.Store.Dto.DeliveryOptionsDto;
import com.haatbazar.backend.Store.Model.DeliveryOptions;
import com.haatbazar.backend.Store.Model.StoreType;
import com.haatbazar.backend.Store.Repository.DeliveryOptionsRepository;
import com.haatbazar.backend.User.dto.user.ResponseDto;
import com.haatbazar.backend.exceptions.CustomException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
public class DeliveryOptionsService {
    private final DeliveryOptionsRepository deliveryOptionsRepository;

    @Autowired
    public DeliveryOptionsService(DeliveryOptionsRepository deliveryOptionsRepository){
        this.deliveryOptionsRepository=deliveryOptionsRepository;

    }
    public ResponseDto DeliveryOptions(DeliveryOptionsDto deliveryOptionsDto) throws CustomException {
        String deliveryOptionsName =deliveryOptionsDto.getDeliveryOptions();
        DeliveryOptions existingType = this.deliveryOptionsRepository.findByDeliveryOptions(deliveryOptionsDto.getDeliveryOptions());
        if (Objects.nonNull(existingType)) {
            throw new CustomException("Delivery Option already exist");
        } else {
            DeliveryOptions newDeliveryOptions = new DeliveryOptions();
            newDeliveryOptions.setDeliveryOptions(deliveryOptionsName);
            newDeliveryOptions.setDescription(deliveryOptionsDto.getDescription());
            this.deliveryOptionsRepository.save(newDeliveryOptions);
            return new ResponseDto("success", "New Delivery Option created");
        }
    }
    public List<DeliveryOptions> getAllDeliveryOptions() {
        return this.deliveryOptionsRepository.findAll();
    }

}

package com.haatbazar.backend.Store.Dto;

import com.haatbazar.backend.Store.Model.DeliveryOptions;
import com.haatbazar.backend.Store.Model.Store;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class StoreDeliveryOptionsDto {
    private List<String> deliveryOptions;
    private String token;

    public StoreDeliveryOptionsDto() {
    }

    public StoreDeliveryOptionsDto(List<String> deliveryOptions, String token) {
        this.deliveryOptions = deliveryOptions;
        this.token = token;
    }
}


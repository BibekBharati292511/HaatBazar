package com.haatbazar.backend.Store.Dto;

import com.haatbazar.backend.Store.Model.DeliveryOptions;
import com.haatbazar.backend.Store.Model.Store;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StoreDeliveryOptionsDto {
    private String deliveryOption;
    private String token;

    public StoreDeliveryOptionsDto() {
    }

    public StoreDeliveryOptionsDto( String deliveryOption, StoreDto store,String token) {
        this.deliveryOption = deliveryOption;
        this.token=token;

    }
}

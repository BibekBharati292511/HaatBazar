package com.haatbazar.backend.Store.Dto;

import com.haatbazar.backend.Store.Model.StoreAddress;
import com.haatbazar.backend.User.Model.Address;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StoreAddressResponseDto {
    private String status;
    private String message;
    private StoreAddress address;

    public StoreAddressResponseDto(String status, String message, StoreAddress address) {
        this.status=status;
        this.message=message;
        this.address=address;
    }
}

package com.haatbazar.backend.User.dto.user;

import com.haatbazar.backend.User.Model.Address;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AddressResponseDto {
    private String status;
    private String message;
    private Address address;

    public AddressResponseDto(String status, String message, Address address) {
        this.status=status;
        this.message=message;
        this.address=address;
    }
}

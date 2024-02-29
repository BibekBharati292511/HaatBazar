package com.haatbazar.backend.User.dto.user;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class AddressDto {
    private String country;
    private String county;
    private Double latitude;
    private Double longitude;
    private String municipality;
    private String state;
    private String cityDistrict;
    private int user_id;

}

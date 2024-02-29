package com.haatbazar.backend.Store.Dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StoreAddressDto {
    private String country;
    private String county;
    private Double latitude;
    private Double longitude;
    private String municipality;
    private String state;
    private String cityDistrict;
    private int store_id;

}

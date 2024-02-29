package com.haatbazar.backend.Store.Dto;

import com.haatbazar.backend.Store.Model.StoreType;
import com.haatbazar.backend.User.Model.AuthenticationToken;
import com.haatbazar.backend.User.Model.User;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StoreDto {
    private String name;
    private String description;
    private byte[] image;
    private String token;
    private StoreType type;
    private String storeNumber;

}

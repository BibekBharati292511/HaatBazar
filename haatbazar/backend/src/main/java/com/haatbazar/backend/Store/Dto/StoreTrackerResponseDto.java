package com.haatbazar.backend.Store.Dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StoreTrackerResponseDto {

    private String status;
    private String message;
    private boolean tracker;



    public StoreTrackerResponseDto(String status, String message,boolean tracker) {
        this.status = status;
        this.message = message;
        this.tracker=tracker;
    }
}

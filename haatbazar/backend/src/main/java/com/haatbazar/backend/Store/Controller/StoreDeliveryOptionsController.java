package com.haatbazar.backend.Store.Controller;

import com.haatbazar.backend.Store.Dto.DeliveryOptionsDto;
import com.haatbazar.backend.Store.Dto.StoreDeliveryOptionsDto;
import com.haatbazar.backend.Store.Service.DeliveryOptionsService;
import com.haatbazar.backend.Store.Service.StoreDeliveryOptionsService;
import com.haatbazar.backend.User.dto.user.ResponseDto;
import com.haatbazar.backend.exceptions.CustomException;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/storeDeliveryOptions")
@RestController
public class StoreDeliveryOptionsController {
    private final StoreDeliveryOptionsService storeDeliveryOptionsService;
    public StoreDeliveryOptionsController(StoreDeliveryOptionsService storeDeliveryOptionsService){
        this.storeDeliveryOptionsService=storeDeliveryOptionsService;
    }
    @PostMapping({"/add"})
    public ResponseDto add(@RequestBody StoreDeliveryOptionsDto storeDeliveryOptionsDto) throws CustomException {
        return this.storeDeliveryOptionsService.storeDeliveryOptions(storeDeliveryOptionsDto);
    }
}

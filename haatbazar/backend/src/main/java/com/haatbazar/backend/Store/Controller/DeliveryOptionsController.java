package com.haatbazar.backend.Store.Controller;

import com.haatbazar.backend.Store.Dto.DeliveryOptionsDto;
import com.haatbazar.backend.Store.Dto.StoreTypeDto;
import com.haatbazar.backend.Store.Model.DeliveryOptions;
import com.haatbazar.backend.Store.Model.StoreType;
import com.haatbazar.backend.Store.Service.DeliveryOptionsService;
import com.haatbazar.backend.User.dto.user.ResponseDto;
import com.haatbazar.backend.exceptions.CustomException;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequestMapping("/deliveryOptions")
@RestController
public class DeliveryOptionsController {
    private final DeliveryOptionsService deliveryOptionsService;
    public DeliveryOptionsController(DeliveryOptionsService deliveryOptionsService){
        this.deliveryOptionsService=deliveryOptionsService;
    }
    @PostMapping({"/add"})
    public ResponseDto add(@RequestBody DeliveryOptionsDto deliveryOptionsDto) throws CustomException {
        return this.deliveryOptionsService.DeliveryOptions(deliveryOptionsDto);
    }
    @GetMapping({"/getDeliveryOptions"})
    public List<DeliveryOptions> getDeliveryOptions() throws CustomException {
        return this.deliveryOptionsService.getAllDeliveryOptions();
    }
}

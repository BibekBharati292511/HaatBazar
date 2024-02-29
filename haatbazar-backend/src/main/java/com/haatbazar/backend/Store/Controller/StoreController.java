package com.haatbazar.backend.Store.Controller;

import com.haatbazar.backend.Store.Dto.StoreDto;
import com.haatbazar.backend.Store.Dto.StoreTypeDto;
import com.haatbazar.backend.Store.Model.StoreType;
import com.haatbazar.backend.Store.Service.StoreService;
import com.haatbazar.backend.User.Model.UserRole;
import com.haatbazar.backend.User.dto.user.ResponseDto;
import com.haatbazar.backend.User.dto.user.SignInDto;
import com.haatbazar.backend.User.dto.user.SignInResponseDto;
import com.haatbazar.backend.User.dto.user.UserRoleDto;
import com.haatbazar.backend.exceptions.AuthenticationFailException;
import com.haatbazar.backend.exceptions.CustomException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequestMapping("/store")
@RestController
public class StoreController {
    @Autowired
    StoreService storeService;


    @PostMapping("/add")
    public ResponseDto add(@RequestBody StoreDto storeDto) throws CustomException {
        return this.storeService.addStore(storeDto);
    }
    @PutMapping("update")
    public ResponseDto update(@RequestBody StoreDto storeDto){
        return this.storeService.updateStore(storeDto);
    }
    @PostMapping({"/setStoreType"})
    public ResponseDto setStoreType(@RequestBody StoreTypeDto storeTypeDto) throws CustomException {
        return this.storeService.StoreType(storeTypeDto);
    }

    @GetMapping({"/getStoreType"})
    public List<StoreType> getStoreType() throws CustomException {
        return this.storeService.getAllStoreTypes();
    }

}

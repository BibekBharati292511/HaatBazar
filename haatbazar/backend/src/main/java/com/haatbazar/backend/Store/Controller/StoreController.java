package com.haatbazar.backend.Store.Controller;

import com.haatbazar.backend.Store.Dto.StoreDto;
import com.haatbazar.backend.Store.Dto.StoreTrackerResponseDto;
import com.haatbazar.backend.Store.Dto.StoreTypeDto;
import com.haatbazar.backend.Store.Model.Store;
import com.haatbazar.backend.Store.Model.StoreType;
import com.haatbazar.backend.Store.Repository.StoreRepository;
import com.haatbazar.backend.Store.Service.StoreService;
import com.haatbazar.backend.User.Model.AuthenticationToken;
import com.haatbazar.backend.User.Model.User;
import com.haatbazar.backend.User.dto.user.ResponseDto;
import com.haatbazar.backend.exceptions.CustomException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

@RequestMapping("/store")
@RestController
public class StoreController {
    @Autowired
    StoreService storeService;
    @Autowired
    StoreRepository storeRepository;

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
    @PostMapping({"/checkStoreProfileStats"})
    public StoreTrackerResponseDto checkStoreProfileStatus(@RequestBody Store store){
        return this.storeService.checkStoreProfileCompleted(store);
    }
    @PostMapping({"/checkStoreImageStats"})
    public StoreTrackerResponseDto checkStoreImageStatus(@RequestBody Store store){
        return this.storeService.checkStoreImageCompleted(store);
    }
    @PostMapping({"/checkStoreNumberStats"})
    public StoreTrackerResponseDto checkStoreNumberStatus(@RequestBody Store store){
        return this.storeService.checkStoreNumberCompleted(store);
    }
    @GetMapping("/getStores")
    public ResponseEntity<List<Store>> getStores(@RequestParam String token) {
        if (!storeRepository.existsByToken(token)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        Store store = storeRepository.findByToken(token);
        List<Store> stores = Collections.singletonList(store);
        return ResponseEntity.ok().body(stores);
    }

}

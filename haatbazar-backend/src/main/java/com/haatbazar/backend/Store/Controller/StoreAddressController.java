package com.haatbazar.backend.Store.Controller;

import com.haatbazar.backend.Store.Dto.StoreAddressDto;
import com.haatbazar.backend.Store.Dto.StoreAddressResponseDto;
import com.haatbazar.backend.Store.Model.StoreAddress;
import com.haatbazar.backend.Store.Service.StoreAddressService;
import com.haatbazar.backend.User.Model.Address;
import com.haatbazar.backend.User.Service.AddressService;
import com.haatbazar.backend.User.dto.user.AddressDto;
import com.haatbazar.backend.User.dto.user.AddressResponseDto;
import com.haatbazar.backend.User.dto.user.ResponseDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RequestMapping({"storeAddress"})
@RestController()
public class StoreAddressController {
    @Autowired
    StoreAddressService storeAddressService;
    @PostMapping("/add")
    public ResponseDto addAddress(@RequestBody StoreAddressDto storeAddressDto) {
        int storeId = storeAddressDto.getStore_id();
        try {
            // Call the service method to add the address
            return storeAddressService.addAddress(storeId, storeAddressDto);
        } catch (Exception e) {
            // If an exception occurs, return an error response DTO
            return new ResponseDto("Error", "Failed to add address: " + e.getMessage());
        }
    }
    @PostMapping({"/checkAddressStats"})
    public ResponseDto checkProfileStatus(@RequestBody StoreAddress storeAddress){
        return this.storeAddressService.checkAddressStatus(storeAddress);
    }
    @PutMapping("/updateAddress")
    public ResponseDto updateAddress(@RequestBody StoreAddressDto storeAddressDto){
        int userId = storeAddressDto.getStore_id();
        try{
            return storeAddressService.updateAddress(userId,storeAddressDto);
        }
        catch (Exception e) {
            // If an exception occurs, return an error response DTO
            return new ResponseDto("Error", "Failed to set address: " + e.getMessage());
        }
    }
    //    @GetMapping("/get")
//    public ResponseEntity<?> getAddressById(@RequestHeader("UserId") int userId) {
//        AuthenticationToken authenticationToken = tokenRepository.findTokenByToken(token);
//        if (authenticationToken == null) {
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
//        }
//
//        User user = authenticationToken.getUser();
//        if (user == null) {
//            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
//        }
//    }
    @GetMapping("/getUserAddress")
    public StoreAddressResponseDto getAddress(@RequestParam("store_id") int storeId) {
        return storeAddressService.getAddressByStoreId(storeId);
    }

}

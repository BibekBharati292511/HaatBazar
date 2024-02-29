package com.haatbazar.backend.User.Controller;

import com.haatbazar.backend.User.Model.Address;
import com.haatbazar.backend.User.Service.AddressService;
import com.haatbazar.backend.User.dto.user.AddressDto;
import com.haatbazar.backend.User.dto.user.AddressResponseDto;
import com.haatbazar.backend.User.dto.user.ResponseDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RequestMapping({"address"})
@RestController()
public class AddressController {
    @Autowired
    AddressService addressService;
    @PostMapping("/add")
    public ResponseDto addAddress(@RequestBody AddressDto addressDto) {
        int userId = addressDto.getUser_id();
        try {
            // Call the service method to add the address
            return addressService.addAddress(userId, addressDto);
        } catch (Exception e) {
            // If an exception occurs, return an error response DTO
            return new ResponseDto("Error", "Failed to add address: " + e.getMessage());
        }
    }
    @PostMapping({"/checkAddressStats"})
    public ResponseDto checkProfileStatus(@RequestBody Address address){
        return this.addressService.checkAddressStatus(address);
    }
    @PutMapping("/updateAddress")
    public ResponseDto updateAddress(@RequestBody AddressDto addressDto){
        int userId = addressDto.getUser_id();
        try{
            return addressService.updateAddress(userId,addressDto);
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
public AddressResponseDto getAddress(@RequestParam("user_id") int userId) {
    return addressService.getAddressByUserId(userId);
}

}

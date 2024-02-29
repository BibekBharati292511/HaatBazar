package com.haatbazar.backend.Store.Service;

import com.haatbazar.backend.Store.Dto.StoreAddressDto;
import com.haatbazar.backend.Store.Dto.StoreAddressResponseDto;
import com.haatbazar.backend.Store.Model.Store;
import com.haatbazar.backend.Store.Model.StoreAddress;
import com.haatbazar.backend.Store.Repository.StoreAddressRepository;
import com.haatbazar.backend.User.Model.Address;
import com.haatbazar.backend.User.Model.User;
import com.haatbazar.backend.User.Repository.AddressRepository;
import com.haatbazar.backend.User.dto.user.AddressDto;
import com.haatbazar.backend.User.dto.user.AddressResponseDto;
import com.haatbazar.backend.User.dto.user.ResponseDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Optional;


@Service
public class StoreAddressService {
    @Autowired
    StoreAddressRepository storeAddressRepository;


    public StoreAddressResponseDto getAddressByStoreId(int storeId) {
        try {
            // Retrieve the address from the database by user ID
            Optional<StoreAddress> optionalAddress = storeAddressRepository.findByStoreId(storeId);
            if (optionalAddress.isPresent()) {
                // If the address is found, return it as a response DTO
                StoreAddress address = optionalAddress.get();
                return new StoreAddressResponseDto("Success", "Address retrieved successfully", address);
            } else {
                // If the address is not found, return an error response DTO
                return new StoreAddressResponseDto("Error", "Address not found", null);
            }
        } catch (Exception e) {
            // If an exception occurs, create and return an error response DTO
            return new StoreAddressResponseDto("Error", "Failed to retrieve address: " + e.getMessage(), null);
        }
    }

    public ResponseDto addAddress(int storeId, StoreAddressDto storeAddressDto) {
        try {
            Optional<StoreAddress> optionalAddress = storeAddressRepository.findByStoreId(storeId);
            if (optionalAddress.isPresent()) {
                StoreAddress address = optionalAddress.get();
                return new ResponseDto("Error", "Address Already Present");
            } else {
                StoreAddress address = new StoreAddress();
                address.setCountry(storeAddressDto.getCountry());
                address.setCounty(storeAddressDto.getCounty());
                address.setLatitude(storeAddressDto.getLatitude());
                address.setLongitude(storeAddressDto.getLongitude());
                address.setMunicipality(storeAddressDto.getMunicipality());
                address.setState(storeAddressDto.getState());
                address.setCityDistrict(storeAddressDto.getCityDistrict());
                address.setStore(new Store(storeId));


                // Save the new address to the database
                storeAddressRepository.save(address);
                // If the address is not found, return an error response DTO
                return new ResponseDto("Success", "Address added successfully");
            }
        } catch (Exception e) {
            // If an exception occurs, create and return an error response DTO
            return new ResponseDto("Error", "Failed to add address: " + e.getMessage());
        }
    }

    public ResponseDto updateAddress(int storeId, StoreAddressDto storeAddressDto) {
        try {
            // Retrieve the address from the database by user ID
            Optional<StoreAddress> optionalAddress = storeAddressRepository.findByStoreId(storeId);
            if (optionalAddress.isPresent()) {
                // Update the address properties
                StoreAddress address = optionalAddress.get();
                address.setCountry(storeAddressDto.getCountry());
                address.setCounty(storeAddressDto.getCounty());
                address.setLatitude(storeAddressDto.getLatitude());
                address.setLongitude(storeAddressDto.getLongitude());
                address.setMunicipality(storeAddressDto.getMunicipality());
                address.setState(storeAddressDto.getState());
                address.setCityDistrict(storeAddressDto.getCityDistrict());
                // Save the updated address to the database
                storeAddressRepository.save(address);

                // Create and return a success response DTO
                return new ResponseDto("Success", "Address updated successfully");
            } else {
                // If the address is not found, return an error response DTO
                return new ResponseDto("Error", "Address not found");
            }
        } catch (Exception e) {
            // If an exception occurs, create and return an error response DTO
            return new ResponseDto("Error", "Failed to update address: " + e.getMessage());
        }
    }

    public ResponseDto deleteAddress(int storeId) {
        try {
            // Retrieve the address from the database by user ID
            Optional<StoreAddress> optionalAddress = storeAddressRepository.findByStoreId(storeId);
            if (optionalAddress.isPresent()) {
                // Delete the address from the database
                storeAddressRepository.delete(optionalAddress.get());

                // Create and return a success response DTO
                return new ResponseDto("Success", "Address deleted successfully");
            } else {
                // If the address is not found, return an error response DTO
                return new ResponseDto("Error", "Address not found");
            }
        } catch (Exception e) {
            // If an exception occurs, create and return an error response DTO
            return new ResponseDto("Error", "Failed to delete address: " + e.getMessage());
        }
    }
    public ResponseDto checkAddressStatus(StoreAddress storeAddress){
        try{
            Optional<StoreAddress> existingAddress = storeAddressRepository.findByStoreId(storeAddress.getId());

            if (existingAddress.isEmpty()) {
                return new ResponseDto("Error", "Address doesnt exists");
            }
            if(existingAddress.get().getCountry()!=null){
                return new ResponseDto("Success","No fields are empty");
            }
            else {
                return new ResponseDto("Error","Profile not completed yet");
            }
        }
        catch (Exception e){
            return new ResponseDto("Error", "Failed to get user status " + e.getMessage());
        }
    }
}

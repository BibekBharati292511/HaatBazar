package com.haatbazar.backend.User.Service;

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
public class AddressService {
    @Autowired
    AddressRepository addressRepository;

    private final String geocodeApiUrl = "https://geocode.maps.co/reverse?lat={lat}&lon={lon}&api_key={api_key}";
    private final String apiKey = "your api key";

    public String getAddress(String latitude, String longitude) {
        RestTemplate restTemplate = new RestTemplate();
        String apiUrl = geocodeApiUrl.replace("{lat}", latitude)
                .replace("{lon}", longitude)
                .replace("{api_key}", apiKey);
        return restTemplate.getForObject(apiUrl, String.class);
    }

    public AddressResponseDto getAddressByUserId(int userId) {
        try {
            // Retrieve the address from the database by user ID
            Optional<Address> optionalAddress = addressRepository.findByUserId(userId);
            if (optionalAddress.isPresent()) {
                // If the address is found, return it as a response DTO
                Address address = optionalAddress.get();
                return new AddressResponseDto("Success", "Address retrieved successfully", address);
            } else {
                // If the address is not found, return an error response DTO
                return new AddressResponseDto("Error", "Address not found", null);
            }
        } catch (Exception e) {
            // If an exception occurs, create and return an error response DTO
            return new AddressResponseDto("Error", "Failed to retrieve address: " + e.getMessage(), null);
        }
    }

    public ResponseDto addAddress(int userId, AddressDto addressDto) {
        try {
            Optional<Address> optionalAddress = addressRepository.findByUserId(userId);
            if (optionalAddress.isPresent()) {
                Address address = optionalAddress.get();
                return new ResponseDto("Error", "Address Already Present");
            } else {
                Address address = new Address();
                address.setCountry(addressDto.getCountry());
                address.setCounty(addressDto.getCounty());
                address.setLatitude(addressDto.getLatitude());
                address.setLongitude(addressDto.getLongitude());
                address.setMunicipality(addressDto.getMunicipality());
                address.setState(addressDto.getState());
                address.setCityDistrict(addressDto.getCityDistrict());
                address.setUser(new User(userId));


                // Save the new address to the database
                addressRepository.save(address);
                // If the address is not found, return an error response DTO
                return new ResponseDto("Success", "Address added successfully");
            }
        } catch (Exception e) {
            // If an exception occurs, create and return an error response DTO
            return new ResponseDto("Error", "Failed to add address: " + e.getMessage());
        }
    }

    public ResponseDto updateAddress(int userId, AddressDto addressDto) {
        try {
            // Retrieve the address from the database by user ID
            Optional<Address> optionalAddress = addressRepository.findByUserId(userId);
            if (optionalAddress.isPresent()) {
                // Update the address properties
                Address address = optionalAddress.get();
                address.setCountry(addressDto.getCountry());
                address.setCounty(addressDto.getCounty());
                address.setLatitude(addressDto.getLatitude());
                address.setLongitude(addressDto.getLongitude());
                address.setMunicipality(addressDto.getMunicipality());
                address.setState(addressDto.getState());
                address.setCityDistrict(addressDto.getCityDistrict());
                // Save the updated address to the database
                addressRepository.save(address);

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

    public ResponseDto deleteAddress(int userId) {
        try {
            // Retrieve the address from the database by user ID
            Optional<Address> optionalAddress = addressRepository.findByUserId(userId);
            if (optionalAddress.isPresent()) {
                // Delete the address from the database
                addressRepository.delete(optionalAddress.get());

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
    public ResponseDto checkAddressStatus(Address address){
        try{
            Optional<Address> existingAddress = addressRepository.findByUserId(address.getId());

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

package com.haatbazar.backend.Store.Service;

import com.haatbazar.backend.Store.Dto.StoreDto;
import com.haatbazar.backend.Store.Dto.StoreTypeDto;
import com.haatbazar.backend.Store.Model.Store;
import com.haatbazar.backend.Store.Model.StoreType;
import com.haatbazar.backend.Store.Repository.StoreRepository;
import com.haatbazar.backend.Store.Repository.StoreTypeRepository;
import com.haatbazar.backend.User.Model.AuthenticationToken;
import com.haatbazar.backend.User.Model.User;
import com.haatbazar.backend.User.Model.UserRole;
import com.haatbazar.backend.User.dto.user.ResponseDto;
import com.haatbazar.backend.User.dto.user.UserRoleDto;
import com.haatbazar.backend.exceptions.CustomException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
public class StoreService {

    private final StoreRepository storeRepository;
    private final StoreTypeRepository storeTypeRepository;

    @Autowired
    public StoreService(StoreRepository storeRepository,StoreTypeRepository storeTypeRepository) {
        this.storeRepository = storeRepository;
        this.storeTypeRepository=storeTypeRepository;
    }


    public ResponseDto addStore(StoreDto storeDto) {
        try {
            //StoreType type=this.storeTypeRepository.findByType(storeDto.getType());
            String token = storeDto.getToken();
            System.out.println(token);

            if (token != null && storeRepository.existsByToken(token)) {
                throw new CustomException("Store has already been created");
            }
            Store store = new Store(storeDto.getName(), storeDto.getDescription(), storeDto.getToken(), storeDto.getType(), storeDto.getStoreNumber(), storeDto.getImage());
            storeRepository.save(store);

            return new ResponseDto("Success","Store added successfully with ID: " + store.getId());
        } catch (CustomException e) {
            return new ResponseDto("Error","Cannot add new store: " + e.getMessage());
        } catch (Exception e) {
            return new ResponseDto("Error","Failed to add store: "+e.getMessage());
        }
    }
    public ResponseDto updateStore(StoreDto storeDto) {
        try {
           // StoreType type=this.storeTypeRepository.findByType(storeDto.getType());
            //StoreType existingType = this.storeTypeRepository.findByType(storeDto.getType());
            String token = storeDto.getToken();
            System.out.println(token);

            Store existingStore = storeRepository.findByToken(token);

            if (existingStore == null) {
                return new ResponseDto("Error", "Store with the provided token does not exist");
            }

            // Update name if provided
            if (storeDto.getName() != null) {
                existingStore.setName(storeDto.getName());
            }

            // Update description if provided
            if (storeDto.getDescription() != null) {
                existingStore.setDescription(storeDto.getDescription());
            }

            // Update type if provided
            if (storeDto.getType()!=null) {
                existingStore.setType(storeDto.getType());
            }

            // Update store number if provided
            if (storeDto.getStoreNumber() != null) {
                existingStore.setPhone_number(storeDto.getStoreNumber());
            }

            // Update image if provided
            if (storeDto.getImage() != null) {
                existingStore.setImage(storeDto.getImage());
            }

            // Save the updated store information
            storeRepository.save(existingStore);

            return new ResponseDto("Success", "Store information updated successfully");
        } catch (Exception e) {
            return new ResponseDto("Error", "Failed to update store: " + e.getMessage());
        }
    }
    public ResponseDto StoreType(StoreTypeDto storeTypeDto) throws CustomException {
        String typeName =storeTypeDto.getType();
        StoreType existingType = this.storeTypeRepository.findByType(typeName);
        if (Objects.nonNull(existingType)) {
            throw new CustomException("Store Type already exists");
        } else {
            StoreType newType = new StoreType();
            newType.setType(typeName);
            this.storeTypeRepository.save(newType);
            return new ResponseDto("success", "Store Type created successfully");
        }
    }

    public List<StoreType> getAllStoreTypes() {
        return this.storeTypeRepository.findAll();
    }


}

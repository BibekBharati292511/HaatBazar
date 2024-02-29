package com.haatbazar.backend.Store.Repository;

import com.haatbazar.backend.Store.Model.StoreType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StoreTypeRepository extends JpaRepository<StoreType, Integer> {
    StoreType findByType(String type);

    StoreType findTypeById(int type);
}

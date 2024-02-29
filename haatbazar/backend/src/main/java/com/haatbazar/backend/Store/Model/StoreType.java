package com.haatbazar.backend.Store.Model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name="store_type")
public class StoreType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(
            name = "type"
    )
    private String type;
    @Column(
            name="description"
    )
    private String description;

    public StoreType(String type,String description) {
        this.type = type;
        this.description=description;
    }

    public StoreType() {

    }
}

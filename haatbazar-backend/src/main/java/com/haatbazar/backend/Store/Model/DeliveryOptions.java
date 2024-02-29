package com.haatbazar.backend.Store.Model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name="delivery_options")
public class DeliveryOptions {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(
            name = "delivery_option"
    )
    private String deliveryOptions;
    @Column(name="description")
    private String description;

    public DeliveryOptions(String delivery_options,String description){

        this.deliveryOptions=delivery_options;
        this.description=description;
    }
    public DeliveryOptions(){}
}

package com.haatbazar.backend.Store.Model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "store_delivery_options")
public class StoreDeliveryOptions {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "delivery_option_id")
    private DeliveryOptions deliveryOption;

    @ManyToOne
    @JoinColumn(name = "store_id")
    private Store store;

    public StoreDeliveryOptions() {
    }

    public StoreDeliveryOptions(DeliveryOptions deliveryOption, Store store) {
        this.deliveryOption = deliveryOption;
        this.store = store;
    }
}

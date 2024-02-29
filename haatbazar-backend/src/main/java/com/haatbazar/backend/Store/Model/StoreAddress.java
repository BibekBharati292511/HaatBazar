package com.haatbazar.backend.Store.Model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;


@Setter
@Getter
@Entity
@Table(name = "address")
public class StoreAddress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "country")
    private String country;

    @Column(name = "county")
    private String county;

    @Column(name = "latitude")
    private Double latitude;

    @Column(name = "longitude")
    private Double longitude;

    @Column(name = "municipality")
    private String municipality;

    @Column(name = "state")
    private String state;

    @Column(name = "city_district")
    private String cityDistrict;

    @ManyToOne
    @JoinColumn(name = "store_id", referencedColumnName = "id")
    private Store store;

    // Constructors, getters, and setters

    public StoreAddress() {
    }

    public StoreAddress(String country, String county, Double latitude, Double longitude, String municipality,
                        String state, String cityDistrict, Store store) {
        this.country = country;
        this.county = county;
        this.latitude = latitude;
        this.longitude = longitude;
        this.municipality = municipality;
        this.state = state;
        this.cityDistrict = cityDistrict;
        this.store = store;
    }
}

package com.haatbazar.backend.User.Model;

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
public class Address {

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
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private User user;

    // Constructors, getters, and setters

    public Address() {
    }

    public Address(String country, String county, Double latitude, Double longitude, String municipality,
                   String state, String cityDistrict, User user) {
        this.country = country;
        this.county = county;
        this.latitude = latitude;
        this.longitude = longitude;
        this.municipality = municipality;
        this.state = state;
        this.cityDistrict = cityDistrict;
        this.user = user;
    }
    public Address(int userId) {
        this.user = new User(userId);
    }


    public void setUser(User user) {
        this.user = user;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public void setCounty(String county) {
        this.county = county;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public void setMunicipality(String municipality) {
        this.municipality = municipality;
    }

    public void setState(String state) {
        this.state = state;
    }

    public void setCityDistrict(String cityDistrict) {
        this.cityDistrict = cityDistrict;
    }

    public void setId(int id) {
        this.id = id;
    }

}

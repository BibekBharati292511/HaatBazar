package com.haatbazar.backend.Store.Model;

import com.haatbazar.backend.User.Model.AuthenticationToken;
import com.haatbazar.backend.User.Model.User;
import com.haatbazar.backend.User.Model.UserRole;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Qualifier;

@Getter
@Setter
@Entity

@Table(name="store_info")
public class Store {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "name")
    private String name;

    @Column(name="description")
    private String description;

    @Column(name="user_token")
    private String token;

    @ManyToOne
    @JoinColumn(
            name = "store_type_id"
    )
    private StoreType type;

    @Column(name="phone_number")
    private String phone_number;

    @Lob
    @Column(name = "image")
    private byte[] image;

    public Store(String name, String description, String token, StoreType type, String phone_number, byte[] image) {
        this.name = name;
        this.description = description;
        this.token = token;
        this.type = type;
        this.phone_number = phone_number;
        this.image = image;
    }

    public Store() {

    }

    public Store(int storeId) {
        this.id=storeId;
    }
}

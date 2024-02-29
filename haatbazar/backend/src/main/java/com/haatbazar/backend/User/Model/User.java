

package com.haatbazar.backend.User.Model;

import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(
            strategy = GenerationType.IDENTITY
    )
    private Integer id;
    @Column(
            name = "first_name"
    )
    private String firstName;
    @Column(
            name = "last_name"
    )
    private String lastName;
    @Column(
            name = "email"
    )
    private String email;
    @Column(
            name = "password"
    )
    private String password;
    @ManyToOne
    @JoinColumn(
            name = "role_id"
    )
    private UserRole role;

    @Column(name="phone_number")
    private String phone_number;

    @Transient
    private String newPassword;
    @Lob
    @Column(name = "image")
    private byte[] image;

    public User(Object firstName, Object lastName, Object email, Object password, UserRole role) {
        this.firstName = (String)firstName;
        this.lastName = (String)lastName;
        this.email = (String)email;
        this.password = (String)password;
        this.role = role;
    }

    public User(int userId) {
        this.id = userId;
    }

    public UserRole getRole() {
        return this.role;
    }

    public void setRole(UserRole role) {
        this.role = role;
    }

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getFirstName() {
        return this.firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return this.lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return this.email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return this.password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }

    public String getPhone_number() {
        return phone_number;
    }

    public void setPhone_number(String phone_number) {
        this.phone_number = phone_number;
    }

    public byte[] getImage() {
        return image;
    }

    public void setImage(byte[] image) {
        this.image = image;
    }

    public User() {
    }
}

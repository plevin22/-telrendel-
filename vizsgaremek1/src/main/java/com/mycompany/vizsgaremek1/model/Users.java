package com.mycompany.vizsgaremek1.model;

import java.io.Serializable;
import java.sql.Timestamp;
import javax.persistence.*;

@Entity
@Table(name = "users")
public class Users implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "name", length = 255)
    private String name;

    @Column(name = "username", length = 255, unique = true)
    private String username;

    @Column(name = "email", length = 255, unique = true)
    private String email;

    @Column(name = "password", length = 255)
    private String password;

    @Column(name = "phone", length = 50)
    private String phone;

    @Enumerated(EnumType.STRING)
    @Column(name = "role")
    private UserRole role = UserRole.customer;

    @Column(name = "banned")
    private Integer banned = 0;

    @Column(name = "created_at", insertable = false, updatable = false)
    private Timestamp createdAt;

    public enum UserRole {
        customer,
        admin,
        restaurant_owner
    }

    public Users() {
    }

    public Users(String name, String username, String email, String password, String phone, UserRole role) {
        this.name = name;
        this.username = username;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.role = role;
        this.banned = 0;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public UserRole getRole() {
        return role;
    }

    public void setRole(UserRole role) {
        this.role = role;
    }

    public Integer getBanned() {
        return banned;
    }

    public void setBanned(Integer banned) {
        this.banned = banned;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

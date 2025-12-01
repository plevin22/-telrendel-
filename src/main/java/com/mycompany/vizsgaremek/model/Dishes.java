/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.vizsgaremek.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collection;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.Size;

/**
 *
 * @author djhob
 */
@Entity
@Table(name = "dishes")
@NamedQueries({
    @NamedQuery(name = "Dishes.findAll", query = "SELECT d FROM Dishes d"),
    @NamedQuery(name = "Dishes.findByDishId", query = "SELECT d FROM Dishes d WHERE d.dishId = :dishId"),
    @NamedQuery(name = "Dishes.findByName", query = "SELECT d FROM Dishes d WHERE d.name = :name"),
    @NamedQuery(name = "Dishes.findByPrice", query = "SELECT d FROM Dishes d WHERE d.price = :price"),
    @NamedQuery(name = "Dishes.findByImageUrl", query = "SELECT d FROM Dishes d WHERE d.imageUrl = :imageUrl"),
    @NamedQuery(name = "Dishes.findByAvailable", query = "SELECT d FROM Dishes d WHERE d.available = :available")})
public class Dishes implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "dish_id")
    private Integer dishId;
    @Size(max = 255)
    @Column(name = "name")
    private String name;
    @Lob
    @Size(max = 65535)
    @Column(name = "description")
    private String description;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "price")
    private BigDecimal price;
    @Size(max = 255)
    @Column(name = "image_url")
    private String imageUrl;
    @Column(name = "available")
    private Boolean available;
    @JoinColumn(name = "restaurant_id", referencedColumnName = "restaurant_id")
    @ManyToOne(optional = false)
    private Restaurants restaurantId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "dishId")
    private Collection<OrderItems> orderItemsCollection;

    public Dishes() {
    }

    public Dishes(Integer dishId) {
        this.dishId = dishId;
    }

    public Integer getDishId() {
        return dishId;
    }

    public void setDishId(Integer dishId) {
        this.dishId = dishId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Boolean getAvailable() {
        return available;
    }

    public void setAvailable(Boolean available) {
        this.available = available;
    }

    public Restaurants getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(Restaurants restaurantId) {
        this.restaurantId = restaurantId;
    }

    public Collection<OrderItems> getOrderItemsCollection() {
        return orderItemsCollection;
    }

    public void setOrderItemsCollection(Collection<OrderItems> orderItemsCollection) {
        this.orderItemsCollection = orderItemsCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (dishId != null ? dishId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Dishes)) {
            return false;
        }
        Dishes other = (Dishes) object;
        if ((this.dishId == null && other.dishId != null) || (this.dishId != null && !this.dishId.equals(other.dishId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mycompany.vizsgaremek.controller.Dishes[ dishId=" + dishId + " ]";
    }
    
}

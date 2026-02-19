package com.mycompany.vizsgaremek1.model;

import java.io.Serializable;
import javax.persistence.*;

@Entity
@Table(name = "review_items")
public class ReviewItems implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "review_item_id")
    private Integer reviewItemId;

    @Column(name = "review_id", nullable = false)
    private Integer reviewId;

    @Column(name = "dish_id", nullable = false)
    private Integer dishId;

    public ReviewItems() {
    }

    public Integer getReviewItemId() {
        return reviewItemId;
    }

    public void setReviewItemId(Integer reviewItemId) {
        this.reviewItemId = reviewItemId;
    }

    public Integer getReviewId() {
        return reviewId;
    }

    public void setReviewId(Integer reviewId) {
        this.reviewId = reviewId;
    }

    public Integer getDishId() {
        return dishId;
    }

    public void setDishId(Integer dishId) {
        this.dishId = dishId;
    }
}
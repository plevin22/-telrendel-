package com.mycompany.vizsgaremek1.model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Table(name = "delivery")
@NamedQueries({
    @NamedQuery(name = "Delivery.findAll", query = "SELECT d FROM Delivery d"),
    @NamedQuery(name = "Delivery.findByDeliveryId", query = "SELECT d FROM Delivery d WHERE d.deliveryId = :deliveryId"),
    @NamedQuery(name = "Delivery.findByOrderId", query = "SELECT d FROM Delivery d WHERE d.orderId = :orderId")
})
public class Delivery implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "delivery_id")
    private Integer deliveryId;

    @Basic(optional = false)
    @NotNull
    @Column(name = "order_id")
    private Integer orderId;

    @Lob
    @Column(name = "delivery_address")
    private String deliveryAddress;

    @Column(name = "delivery_time")
    @Temporal(TemporalType.TIMESTAMP)
    private Date deliveryTime;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private DeliveryStatus status = DeliveryStatus.pending;

    public enum DeliveryStatus {
        pending, dispatched, delivering, completed, failed
    }

    public Delivery() {
    }

    public Integer getDeliveryId() {
        return deliveryId;
    }

    public void setDeliveryId(Integer deliveryId) {
        this.deliveryId = deliveryId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public Date getDeliveryTime() {
        return deliveryTime;
    }

    public void setDeliveryTime(Date deliveryTime) {
        this.deliveryTime = deliveryTime;
    }

    public DeliveryStatus getStatus() {
        return status;
    }

    public void setStatus(DeliveryStatus status) {
        this.status = status;
    }

    @Override
    public int hashCode() {
        return deliveryId != null ? deliveryId.hashCode() : 0;
    }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof Delivery)) {
            return false;
        }
        Delivery other = (Delivery) obj;
        return deliveryId != null && deliveryId.equals(other.deliveryId);
    }
}

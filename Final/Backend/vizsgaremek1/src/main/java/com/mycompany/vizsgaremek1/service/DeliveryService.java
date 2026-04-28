package com.mycompany.vizsgaremek1.service;

import com.mycompany.vizsgaremek1.model.Delivery;
import java.util.Date;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.*;

@Stateless
public class DeliveryService {

    @PersistenceContext(unitName = "com.mycompany_vizsgaremek1_war_1.0-SNAPSHOTPU")
    private EntityManager em;

    public Delivery findDeliveryById(Integer deliveryId) {
        return em.find(Delivery.class, deliveryId);
    }

    @SuppressWarnings("unchecked")
    public List<Delivery> getDeliveryByOrder(Integer orderId) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("GetDeliveryByOrder", Delivery.class);
        sp.registerStoredProcedureParameter("p_order_id", Integer.class, ParameterMode.IN);
        sp.setParameter("p_order_id", orderId);
        return sp.getResultList();
    }

    @SuppressWarnings("unchecked")
    public List<Delivery> getPendingDeliveries() {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("GetPendingDeliveries", Delivery.class);
        return sp.getResultList();
    }

    public void addDelivery(Integer orderId, String deliveryAddress, Date deliveryTime, String status) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("AddDelivery");
        sp.registerStoredProcedureParameter("p_order_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_delivery_address", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_delivery_time", Date.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_status", String.class, ParameterMode.IN);
        sp.setParameter("p_order_id", orderId);
        sp.setParameter("p_delivery_address", deliveryAddress);
        sp.setParameter("p_delivery_time", deliveryTime);
        sp.setParameter("p_status", status != null ? status : "pending");
        sp.execute();
    }

    public void updateDeliveryStatus(Integer deliveryId, String status) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("UpdateDeliveryStatus");
        sp.registerStoredProcedureParameter("p_delivery_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_status", String.class, ParameterMode.IN);
        sp.setParameter("p_delivery_id", deliveryId);
        sp.setParameter("p_status", status);
        sp.execute();
    }

    public void deleteDelivery(Integer deliveryId) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("DeleteDelivery");
        sp.registerStoredProcedureParameter("p_delivery_id", Integer.class, ParameterMode.IN);
        sp.setParameter("p_delivery_id", deliveryId);
        sp.execute();
    }

    public boolean orderExists(Integer orderId) {
        Long count = em.createQuery("SELECT COUNT(o) FROM Orders o WHERE o.orderId = :id", Long.class)
                .setParameter("id", orderId).getSingleResult();
        return count > 0;
    }
}

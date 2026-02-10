package com.mycompany.vizsgaremek1.service;

import com.mycompany.vizsgaremek1.model.Orders;
import java.math.BigDecimal;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.*;

@Stateless
public class OrdersService {

    @PersistenceContext(unitName = "com.mycompany_vizsgaremek1_war_1.0-SNAPSHOTPU")
    private EntityManager em;

    /**
     * Rendelés keresése ID alapján.
     */
    public Orders findOrderById(Integer orderId) {
        return em.find(Orders.class, orderId);
    }

    /**
     * Összes rendelés lekérdezése.
     */
    @SuppressWarnings("unchecked")
    public List<Orders> getAllOrders() {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("GetAllOrders", Orders.class);
        return sp.getResultList();
    }

    /**
     * Rendelések lekérdezése felhasználó alapján.
     */
    public List<Orders> getOrdersByUserId(Integer userId) {
        return em.createQuery(
            "SELECT o FROM Orders o WHERE o.userId = :userId ORDER BY o.createdAt DESC", Orders.class
        ).setParameter("userId", userId).getResultList();
    }

    /**
     * Új rendelés létrehozása - AddOrder eljárás.
     * JAVÍTVA: delivery_address paraméter hozzáadva!
     */
    public void addOrder(Integer userId, Integer restaurantId, String deliveryAddress, String status, BigDecimal totalPrice) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("AddOrder");
        
        sp.registerStoredProcedureParameter("p_user_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_restaurant_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_delivery_address", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_status", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_total_price", BigDecimal.class, ParameterMode.IN);

        sp.setParameter("p_user_id", userId);
        sp.setParameter("p_restaurant_id", restaurantId);
        sp.setParameter("p_delivery_address", deliveryAddress != null ? deliveryAddress : "Nincs megadva");
        sp.setParameter("p_status", status);
        sp.setParameter("p_total_price", totalPrice);

        sp.execute();
    }

    /**
     * Rendelés frissítése - UpdateOrder eljárás.
     */
    public void updateOrder(Integer orderId, String status, BigDecimal totalPrice) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("UpdateOrder");
        
        sp.registerStoredProcedureParameter("p_order_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_status", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_total_price", BigDecimal.class, ParameterMode.IN);

        sp.setParameter("p_order_id", orderId);
        sp.setParameter("p_status", status);
        sp.setParameter("p_total_price", totalPrice);

        sp.execute();
    }

    /**
     * Rendelés törlése - DeleteOrder eljárás.
     */
    public void deleteOrder(Integer orderId) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("DeleteOrder");
        sp.registerStoredProcedureParameter("p_order_id", Integer.class, ParameterMode.IN);
        sp.setParameter("p_order_id", orderId);
        sp.execute();
    }

    /**
     * Felhasználó létezésének ellenőrzése.
     */
    public boolean userExists(Integer userId) {
        Long count = em.createQuery(
            "SELECT COUNT(u) FROM Users u WHERE u.userId = :id", Long.class
        ).setParameter("id", userId).getSingleResult();
        return count > 0;
    }

    /**
     * Étterem létezésének ellenőrzése.
     */
    public boolean restaurantExists(Integer restaurantId) {
        Long count = em.createQuery(
            "SELECT COUNT(r) FROM Restaurants r WHERE r.restaurantId = :id", Long.class
        ).setParameter("id", restaurantId).getSingleResult();
        return count > 0;
    }

    /**
     * Legutolsó rendelés lekérése user alapján.
     */
    public Orders getLastOrderByUser(Integer userId) {
        try {
            return em.createQuery(
                "SELECT o FROM Orders o WHERE o.userId = :userId ORDER BY o.createdAt DESC", Orders.class
            ).setParameter("userId", userId)
             .setMaxResults(1)
             .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    /**
     * Legutolsó rendelés lekérése user és restaurant alapján.
     */
    public Orders getLastOrderByUserAndRestaurant(Integer userId, Integer restaurantId) {
        try {
            return em.createQuery(
                "SELECT o FROM Orders o WHERE o.userId = :userId AND o.restaurantId = :restaurantId ORDER BY o.createdAt DESC", Orders.class
            ).setParameter("userId", userId)
             .setParameter("restaurantId", restaurantId)
             .setMaxResults(1)
             .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    /**
     * Rendelés végösszegének újraszámítása az order_items alapján.
     */
    public BigDecimal recalculateOrderTotal(Integer orderId) {
        try {
            BigDecimal total = em.createQuery(
                "SELECT COALESCE(SUM(oi.price), 0) FROM OrderItems oi WHERE oi.orderId = :orderId", BigDecimal.class
            ).setParameter("orderId", orderId).getSingleResult();
            
            Orders order = findOrderById(orderId);
            if (order != null) {
                updateOrder(orderId, order.getStatus().toString(), total);
            }
            
            return total;
        } catch (Exception e) {
            e.printStackTrace();
            return BigDecimal.ZERO;
        }
    }

    /**
     * Rendelés végösszegének lekérdezése (order_items alapján számolva).
     */
    public BigDecimal getOrderTotal(Integer orderId) {
        try {
            return em.createQuery(
                "SELECT COALESCE(SUM(oi.price), 0) FROM OrderItems oi WHERE oi.orderId = :orderId", BigDecimal.class
            ).setParameter("orderId", orderId).getSingleResult();
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }
}
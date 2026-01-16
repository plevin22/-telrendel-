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
            "SELECT o FROM Orders o WHERE o.userId = :userId", Orders.class
        ).setParameter("userId", userId).getResultList();
    }

    /**
     * Rendelések lekérdezése étterem alapján.
     */
    public List<Orders> getOrdersByRestaurantId(Integer restaurantId) {
        return em.createQuery(
            "SELECT o FROM Orders o WHERE o.restaurantId = :restaurantId", Orders.class
        ).setParameter("restaurantId", restaurantId).getResultList();
    }

    /**
     * Új rendelés létrehozása - AddOrder eljárás.
     */
    public void addOrder(Integer userId, Integer restaurantId, String status, BigDecimal totalPrice) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("AddOrder");
        
        sp.registerStoredProcedureParameter("user_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("restaurant_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("status", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("total_price", BigDecimal.class, ParameterMode.IN);

        sp.setParameter("user_id", userId);
        sp.setParameter("restaurant_id", restaurantId);
        sp.setParameter("status", status);
        sp.setParameter("total_price", totalPrice);

        sp.execute();
    }

    /**
     * Rendelés frissítése - UpdateOrder eljárás.
     */
    public void updateOrder(Integer orderId, String status, BigDecimal totalPrice) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("UpdateOrder");
        
        sp.registerStoredProcedureParameter("order_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("status", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("total_price", BigDecimal.class, ParameterMode.IN);

        sp.setParameter("order_id", orderId);
        sp.setParameter("status", status);
        sp.setParameter("total_price", totalPrice);

        sp.execute();
    }

    /**
     * Rendelés törlése - DeleteOrder eljárás.
     */
    public void deleteOrder(Integer orderId) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("DeleteOrder");
        sp.registerStoredProcedureParameter("order_id", Integer.class, ParameterMode.IN);
        sp.setParameter("order_id", orderId);
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
}
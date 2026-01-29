package com.mycompany.vizsgaremek1.service;

import com.mycompany.vizsgaremek1.model.Dishes;
import com.mycompany.vizsgaremek1.model.OrderItems;
import java.math.BigDecimal;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.*;

@Stateless
public class OrderItemsService {

    @PersistenceContext(unitName = "com.mycompany_vizsgaremek1_war_1.0-SNAPSHOTPU")
    private EntityManager em;

    /**
     * Rendelési tétel keresése ID alapján.
     */
    public OrderItems findOrderItemById(Integer orderItemId) {
        return em.find(OrderItems.class, orderItemId);
    }

    /**
     * Összes rendelési tétel lekérdezése.
     */
    @SuppressWarnings("unchecked")
    public List<OrderItems> getAllOrderItems() {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("GetAllOrderItems", OrderItems.class);
        return sp.getResultList();
    }

    /**
     * Rendelési tételek lekérdezése rendelés alapján.
     */
    public List<OrderItems> getOrderItemsByOrderId(Integer orderId) {
        return em.createQuery(
            "SELECT oi FROM OrderItems oi WHERE oi.orderId = :orderId", OrderItems.class
        ).setParameter("orderId", orderId).getResultList();
    }

    /**
     * Étel lekérdezése ID alapján (ár ellenőrzéshez).
     */
    public Dishes findDishById(Integer dishId) {
        return em.find(Dishes.class, dishId);
    }

    /**
     * Étel árának lekérdezése.
     */
    public BigDecimal getDishPrice(Integer dishId) {
        Dishes dish = findDishById(dishId);
        if (dish != null) {
            return dish.getPrice();
        }
        return null;
    }

    /**
     * Új rendelési tétel létrehozása - AddOrderItem eljárás.
     * Az ár automatikusan számítódik az étel ára alapján!
     */
    public void addOrderItem(Integer orderId, Integer dishId, Integer quantity, BigDecimal price) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("AddOrderItem");
        
        sp.registerStoredProcedureParameter("p_order_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_dish_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_quantity", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_price", BigDecimal.class, ParameterMode.IN);

        sp.setParameter("p_order_id", orderId);
        sp.setParameter("p_dish_id", dishId);
        sp.setParameter("p_quantity", quantity);
        sp.setParameter("p_price", price);

        sp.execute();
    }

    /**
     * Rendelési tétel frissítése - UpdateOrderItem eljárás.
     */
    public void updateOrderItem(Integer orderItemId, Integer quantity, BigDecimal price) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("UpdateOrderItem");
        
        sp.registerStoredProcedureParameter("p_order_item_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_quantity", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_price", BigDecimal.class, ParameterMode.IN);

        sp.setParameter("p_order_item_id", orderItemId);
        sp.setParameter("p_quantity", quantity);
        sp.setParameter("p_price", price);

        sp.execute();
    }

    /**
     * Rendelési tétel törlése - DeleteOrderItem eljárás.
     */
    public void deleteOrderItem(Integer orderItemId) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("DeleteOrderItem");
        sp.registerStoredProcedureParameter("p_order_item_id", Integer.class, ParameterMode.IN);
        sp.setParameter("p_order_item_id", orderItemId);
        sp.execute();
    }

    /**
     * Rendelés létezésének ellenőrzése.
     */
    public boolean orderExists(Integer orderId) {
        Long count = em.createQuery(
            "SELECT COUNT(o) FROM Orders o WHERE o.orderId = :id", Long.class
        ).setParameter("id", orderId).getSingleResult();
        return count > 0;
    }

    /**
     * Étel létezésének ellenőrzése.
     */
    public boolean dishExists(Integer dishId) {
        Long count = em.createQuery(
            "SELECT COUNT(d) FROM Dishes d WHERE d.dishId = :id", Long.class
        ).setParameter("id", dishId).getSingleResult();
        return count > 0;
    }

    /**
     * Étel elérhetőségének ellenőrzése.
     */
    public boolean isDishAvailable(Integer dishId) {
        Dishes dish = findDishById(dishId);
        return dish != null && dish.getAvailable();
    }
}
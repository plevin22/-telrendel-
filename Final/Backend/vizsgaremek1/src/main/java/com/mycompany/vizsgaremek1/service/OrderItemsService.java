package com.mycompany.vizsgaremek1.service;

import com.mycompany.vizsgaremek1.model.Dishes;
import com.mycompany.vizsgaremek1.model.OrderItems;
import java.math.BigDecimal;
import java.util.List;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.persistence.*;

@Stateless
public class OrderItemsService {

    @PersistenceContext(unitName = "com.mycompany_vizsgaremek1_war_1.0-SNAPSHOTPU")
    private EntityManager em;

    @EJB
    private OrdersService ordersService;

    public OrderItems findOrderItemById(Integer orderItemId) {
        return em.find(OrderItems.class, orderItemId);
    }

    @SuppressWarnings("unchecked")
    public List<OrderItems> getAllOrderItems() {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("GetAllOrderItems", OrderItems.class);
        return sp.getResultList();
    }

    public List<OrderItems> getOrderItemsByOrderId(Integer orderId) {
        return em.createQuery(
                "SELECT oi FROM OrderItems oi WHERE oi.orderId = :orderId", OrderItems.class
        ).setParameter("orderId", orderId).getResultList();
    }

    public Dishes findDishById(Integer dishId) {
        return em.find(Dishes.class, dishId);
    }

    public BigDecimal getDishPrice(Integer dishId) {
        Dishes dish = findDishById(dishId);
        if (dish != null) {
            return dish.getPrice();
        }
        return null;
    }

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

        ordersService.recalculateOrderTotal(orderId);
    }

    public void updateOrderItem(Integer orderItemId, Integer quantity, BigDecimal price) {
        // Először lekérjük a tételt, hogy tudjuk melyik rendeléshez tartozik
        OrderItems item = findOrderItemById(orderItemId);
        Integer orderId = item != null ? item.getOrderId() : null;

        StoredProcedureQuery sp = em.createStoredProcedureQuery("UpdateOrderItem");

        sp.registerStoredProcedureParameter("p_order_item_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_quantity", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_price", BigDecimal.class, ParameterMode.IN);

        sp.setParameter("p_order_item_id", orderItemId);
        sp.setParameter("p_quantity", quantity);
        sp.setParameter("p_price", price);

        sp.execute();

        if (orderId != null) {
            ordersService.recalculateOrderTotal(orderId);
        }
    }

    public void deleteOrderItem(Integer orderItemId) {
        // Először lekérjük a tételt, hogy tudjuk melyik rendeléshez tartozik
        OrderItems item = findOrderItemById(orderItemId);
        Integer orderId = item != null ? item.getOrderId() : null;

        StoredProcedureQuery sp = em.createStoredProcedureQuery("DeleteOrderItem");
        sp.registerStoredProcedureParameter("p_order_item_id", Integer.class, ParameterMode.IN);
        sp.setParameter("p_order_item_id", orderItemId);
        sp.execute();

        if (orderId != null) {
            ordersService.recalculateOrderTotal(orderId);
        }
    }

    public boolean orderExists(Integer orderId) {
        Long count = em.createQuery(
                "SELECT COUNT(o) FROM Orders o WHERE o.orderId = :id", Long.class
        ).setParameter("id", orderId).getSingleResult();
        return count > 0;
    }

    public boolean dishExists(Integer dishId) {
        Long count = em.createQuery(
                "SELECT COUNT(d) FROM Dishes d WHERE d.dishId = :id", Long.class
        ).setParameter("id", dishId).getSingleResult();
        return count > 0;
    }

    public boolean isDishAvailable(Integer dishId) {
        Dishes dish = findDishById(dishId);
        return dish != null && dish.getAvailable();
    }
}

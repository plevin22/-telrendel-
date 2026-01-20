package com.mycompany.vizsgaremek1.service;

import com.mycompany.vizsgaremek1.model.Dishes;
import java.math.BigDecimal;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.*;

@Stateless
public class DishesService {

    @PersistenceContext(unitName = "com.mycompany_vizsgaremek1_war_1.0-SNAPSHOTPU")
    private EntityManager em;

    /**
     * Étel keresése ID alapján.
     */
    public Dishes findDishById(Integer dishId) {
        return em.find(Dishes.class, dishId);
    }

    /**
     * Összes étel lekérdezése.
     */
    @SuppressWarnings("unchecked")
    public List<Dishes> getAllDishes() {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("GetAllDishes", Dishes.class);
        return sp.getResultList();
    }

    /**
     * Ételek lekérdezése étterem alapján.
     */
    public List<Dishes> getDishesByRestaurantId(Integer restaurantId) {
        return em.createQuery(
            "SELECT d FROM Dishes d WHERE d.restaurantId = :restaurantId", Dishes.class
        ).setParameter("restaurantId", restaurantId).getResultList();
    }

    /**
     * Új étel létrehozása - AddDish eljárás.
     */
    public void addDish(Integer restaurantId, String name, String description, 
                       BigDecimal price, String imageUrl, Boolean available) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("AddDish");
        
        sp.registerStoredProcedureParameter("p_restaurant_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_name", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_description", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_price", BigDecimal.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_image_url", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_available", Boolean.class, ParameterMode.IN);

        sp.setParameter("p_restaurant_id", restaurantId);
        sp.setParameter("p_name", name);
        sp.setParameter("p_description", description);
        sp.setParameter("p_price", price);
        sp.setParameter("p_image_url", imageUrl);
        sp.setParameter("p_available", available);

        sp.execute();
    }

    /**
     * Étel frissítése - UpdateDish eljárás.
     */
    public void updateDish(Integer dishId, String name, String description, 
                          BigDecimal price, String imageUrl, Boolean available) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("UpdateDish");
        
        sp.registerStoredProcedureParameter("p_dish_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_name", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_description", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_price", BigDecimal.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_image_url", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_available", Boolean.class, ParameterMode.IN);

        sp.setParameter("p_dish_id", dishId);
        sp.setParameter("p_name", name);
        sp.setParameter("p_description", description);
        sp.setParameter("p_price", price);
        sp.setParameter("p_image_url", imageUrl);
        sp.setParameter("p_available", available);

        sp.execute();
    }

    /**
     * Étel törlése - DeleteDish eljárás.
     */
    public void deleteDish(Integer dishId) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("DeleteDish");
        sp.registerStoredProcedureParameter("p_dish_id", Integer.class, ParameterMode.IN);
        sp.setParameter("p_dish_id", dishId);
        sp.execute();
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
}

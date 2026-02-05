package com.mycompany.vizsgaremek1.service;

import com.mycompany.vizsgaremek1.model.Restaurants;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.*;

@Stateless
public class RestaurantsService {

    @PersistenceContext(unitName = "com.mycompany_vizsgaremek1_war_1.0-SNAPSHOTPU")
    private EntityManager em;

    public Restaurants findRestaurantById(Integer restaurantId) {
        return em.find(Restaurants.class, restaurantId);
    }

    @SuppressWarnings("unchecked")
    public List<Restaurants> getAllRestaurants() {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("GetAllRestaurants", Restaurants.class);
        return sp.getResultList();
    }

    public void addRestaurant(Integer ownerId, String name, String description, String address, String phone, String openHours) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("AddRestaurant");
        sp.registerStoredProcedureParameter("owner_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("name", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("description", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("address", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("phone", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("open_hours", String.class, ParameterMode.IN);
        sp.setParameter("owner_id", ownerId);
        sp.setParameter("name", name);
        sp.setParameter("description", description);
        sp.setParameter("address", address);
        sp.setParameter("phone", phone);
        sp.setParameter("open_hours", openHours);
        sp.execute();
    }

    public void updateRestaurant(Integer restaurantId, String name, String description, String address, String phone, String openHours) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("UpdateRestaurant");
        sp.registerStoredProcedureParameter("p_restaurant_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_name", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_description", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_address", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_phone", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_open_hours", String.class, ParameterMode.IN);
        sp.setParameter("p_restaurant_id", restaurantId);
        sp.setParameter("p_name", name);
        sp.setParameter("p_description", description);
        sp.setParameter("p_address", address);
        sp.setParameter("p_phone", phone);
        sp.setParameter("p_open_hours", openHours);
        sp.execute();
    }

    public void deleteRestaurant(Integer restaurantId) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("DeleteRestaurant");
        sp.registerStoredProcedureParameter("p_restaurant_id", Integer.class, ParameterMode.IN);
        sp.setParameter("p_restaurant_id", restaurantId);
        sp.execute();
    }

    @SuppressWarnings("unchecked")
    public List<Restaurants> searchRestaurantsByAddress(String address) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("SearchRestaurantsByAddress", Restaurants.class);
        sp.registerStoredProcedureParameter("p_address", String.class, ParameterMode.IN);
        sp.setParameter("p_address", address);
        return sp.getResultList();
    }

    public boolean ownerExists(Integer ownerId) {
        Long count = em.createQuery("SELECT COUNT(u) FROM Users u WHERE u.userId = :id", Long.class)
            .setParameter("id", ownerId).getSingleResult();
        return count > 0;
    }
}

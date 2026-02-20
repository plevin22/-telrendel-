package com.mycompany.vizsgaremek1.service;

import com.mycompany.vizsgaremek1.model.Reviews;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.*;

@Stateless
public class ReviewsService {

    @PersistenceContext(unitName = "com.mycompany_vizsgaremek1_war_1.0-SNAPSHOTPU")
    private EntityManager em;

    /**
     * Értékelés keresése ID alapján.
     */
    public Reviews findReviewById(Integer reviewId) {
        return em.find(Reviews.class, reviewId);
    }

    /**
     * Ellenőrzi, hogy a rendelés létezik-e, completed státuszú-e,
     * és az adott felhasználóé-e.
     */
    public boolean isValidCompletedOrder(Integer orderId, Integer userId) {
        Long count = em.createQuery(
            "SELECT COUNT(o) FROM Orders o WHERE o.orderId = :orderId AND o.userId = :userId AND o.status = 'completed'", Long.class
        ).setParameter("orderId", orderId)
         .setParameter("userId", userId)
         .getSingleResult();
        return count > 0;
    }

    /**
     * Lekérdezi a rendeléshez tartozó étterem ID-t.
     */
    public Integer getRestaurantIdByOrder(Integer orderId) {
        try {
            return em.createQuery(
                "SELECT o.restaurantId FROM Orders o WHERE o.orderId = :orderId", Integer.class
            ).setParameter("orderId", orderId).getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    /**
     * Ellenőrzi, hogy a rendelést már értékelték-e.
     */
    public boolean isOrderAlreadyReviewed(Integer orderId) {
        Long count = em.createQuery(
            "SELECT COUNT(r) FROM Reviews r WHERE r.orderId = :orderId", Long.class
        ).setParameter("orderId", orderId).getSingleResult();
        return count > 0;
    }

    /**
     * Összes értékelés egy étteremhez - GetReviewsByRestaurant eljárás.
     */
    @SuppressWarnings("unchecked")
    public List<Reviews> getReviewsByRestaurant(Integer restaurantId) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("GetReviewsByRestaurant", Reviews.class);
        sp.registerStoredProcedureParameter("p_restaurant_id", Integer.class, ParameterMode.IN);
        sp.setParameter("p_restaurant_id", restaurantId);
        return sp.getResultList();
    }

    /**
     * Összes értékelés egy felhasználótól - GetReviewsByUser eljárás.
     */
    @SuppressWarnings("unchecked")
    public List<Reviews> getReviewsByUser(Integer userId) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("GetReviewsByUser", Reviews.class);
        sp.registerStoredProcedureParameter("p_user_id", Integer.class, ParameterMode.IN);
        sp.setParameter("p_user_id", userId);
        return sp.getResultList();
    }

    /**
     * Legutóbbi értékelések részletekkel.
     */
    @SuppressWarnings("unchecked")
    public List<Object[]> getRecentReviews(Integer limit) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("GetRecentReviews");
        sp.registerStoredProcedureParameter("p_limit", Integer.class, ParameterMode.IN);
        sp.setParameter("p_limit", limit);
        return sp.getResultList();
    }

    /**
     * Étterem átlagos értékelése.
     */
    @SuppressWarnings("unchecked")
    public Object[] getAverageRatingByRestaurant(Integer restaurantId) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("GetAverageRatingByRestaurant");
        sp.registerStoredProcedureParameter("p_restaurant_id", Integer.class, ParameterMode.IN);
        sp.setParameter("p_restaurant_id", restaurantId);
        List<Object[]> results = sp.getResultList();
        if (results != null && !results.isEmpty()) {
            return results.get(0);
        }
        return null;
    }

    /**
     * Új értékelés hozzáadása - natív query mert order_id-t is mentünk.
     * A rendeléshez tartozó ételeket a review_items táblába is menti.
     */
    public Integer addReview(Integer userId, Integer restaurantId, Integer orderId, Integer rating, String comment) {
        // Review beszúrása
        em.createNativeQuery(
            "INSERT INTO reviews (user_id, restaurant_id, order_id, rating, comment) VALUES (?, ?, ?, ?, ?)"
        ).setParameter(1, userId)
         .setParameter(2, restaurantId)
         .setParameter(3, orderId)
         .setParameter(4, rating)
         .setParameter(5, comment)
         .executeUpdate();

        // Utolsó beszúrt review_id lekérése
        Integer reviewId = ((Number) em.createNativeQuery("SELECT LAST_INSERT_ID()").getSingleResult()).intValue();

        // Rendeléshez tartozó ételek mentése a review_items táblába
        em.createNativeQuery(
            "INSERT INTO review_items (review_id, dish_id) SELECT ?, oi.dish_id FROM order_items oi WHERE oi.order_id = ?"
        ).setParameter(1, reviewId)
         .setParameter(2, orderId)
         .executeUpdate();

        return reviewId;
    }

    /**
     * Review-hoz tartozó ételnevek lekérése a review_items táblából.
     */
    @SuppressWarnings("unchecked")
    public List<Object[]> getDishNamesByReviewId(Integer reviewId) {
        return em.createNativeQuery(
            "SELECT d.dish_id, d.name FROM review_items ri JOIN dishes d ON ri.dish_id = d.dish_id WHERE ri.review_id = ?"
        ).setParameter(1, reviewId).getResultList();
    }

    /**
     * Order-hez tartozó ételnevek lekérése az order_items táblából.
     */
    @SuppressWarnings("unchecked")
    public List<Object[]> getDishNamesByOrderId(Integer orderId) {
        return em.createNativeQuery(
            "SELECT d.dish_id, d.name, oi.quantity FROM order_items oi JOIN dishes d ON oi.dish_id = d.dish_id WHERE oi.order_id = ?"
        ).setParameter(1, orderId).getResultList();
    }

    /**
     * Értékelés frissítése - UpdateReview eljárás.
     */
    public void updateReview(Integer reviewId, Integer rating, String comment) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("UpdateReview");
        sp.registerStoredProcedureParameter("p_review_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_rating", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_comment", String.class, ParameterMode.IN);

        sp.setParameter("p_review_id", reviewId);
        sp.setParameter("p_rating", rating);
        sp.setParameter("p_comment", comment);

        sp.execute();
    }

    /**
     * Értékelés törlése - DeleteReview eljárás.
     */
    public void deleteReview(Integer reviewId) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("DeleteReview");
        sp.registerStoredProcedureParameter("p_review_id", Integer.class, ParameterMode.IN);
        sp.setParameter("p_review_id", reviewId);
        sp.execute();
    }

    /**
     * Értékelés keresése komment alapján.
     */
    @SuppressWarnings("unchecked")
    public List<Reviews> searchReviewsByComment(String keyword) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("SearchReviewsByComment", Reviews.class);
        sp.registerStoredProcedureParameter("p_keyword", String.class, ParameterMode.IN);
        sp.setParameter("p_keyword", keyword);
        return sp.getResultList();
    }

    /**
     * Felhasználó név lekérdezése ID alapján.
     */
    public String getUserNameById(Integer userId) {
        try {
            return em.createQuery(
                "SELECT u.name FROM Users u WHERE u.userId = :userId", String.class
            ).setParameter("userId", userId).getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    /**
     * Felhasználó email lekérdezése ID alapján.
     */
    public String getUserEmailById(Integer userId) {
        try {
            return em.createQuery(
                "SELECT u.email FROM Users u WHERE u.userId = :userId", String.class
            ).setParameter("userId", userId).getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    /**
     * Étterem név lekérdezése ID alapján.
     */
    public String getRestaurantNameById(Integer restaurantId) {
        try {
            return em.createQuery(
                "SELECT r.name FROM Restaurants r WHERE r.restaurantId = :restaurantId", String.class
            ).setParameter("restaurantId", restaurantId).getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }
}
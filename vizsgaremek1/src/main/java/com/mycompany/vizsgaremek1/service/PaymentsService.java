package com.mycompany.vizsgaremek1.service;

import com.mycompany.vizsgaremek1.model.Payments;
import java.math.BigDecimal;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.*;

@Stateless
public class PaymentsService {

    @PersistenceContext(unitName = "com.mycompany_vizsgaremek1_war_1.0-SNAPSHOTPU")
    private EntityManager em;

    public Payments findPaymentById(Integer paymentId) {
        return em.find(Payments.class, paymentId);
    }

    @SuppressWarnings("unchecked")
    public List<Payments> getAllPayments() {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("GetAllPayments", Payments.class);
        return sp.getResultList();
    }

    public Payments getPaymentByOrderId(Integer orderId) {
        try {
            return em.createQuery(
                    "SELECT p FROM Payments p WHERE p.orderId = :orderId", Payments.class
            ).setParameter("orderId", orderId).getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public void addPayment(Integer orderId, BigDecimal amount, String method, String status) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("AddPayment");

        sp.registerStoredProcedureParameter("p_order_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_amount", BigDecimal.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_method", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_status", String.class, ParameterMode.IN);

        sp.setParameter("p_order_id", orderId);
        sp.setParameter("p_amount", amount);
        sp.setParameter("p_method", method);
        sp.setParameter("p_status", status);

        sp.execute();
    }

    public void updatePayment(Integer paymentId, String status) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("UpdatePayment");

        sp.registerStoredProcedureParameter("p_payment_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_status", String.class, ParameterMode.IN);

        sp.setParameter("p_payment_id", paymentId);
        sp.setParameter("p_status", status);

        sp.execute();
    }

    public void deletePayment(Integer paymentId) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("DeletePayment");
        sp.registerStoredProcedureParameter("p_payment_id", Integer.class, ParameterMode.IN);
        sp.setParameter("p_payment_id", paymentId);
        sp.execute();
    }

    public boolean orderExists(Integer orderId) {
        Long count = em.createQuery(
                "SELECT COUNT(o) FROM Orders o WHERE o.orderId = :id", Long.class
        ).setParameter("id", orderId).getSingleResult();
        return count > 0;
    }
}

package com.mycompany.vizsgaremek1.service;

import com.mycompany.vizsgaremek1.model.PasswordResetToken;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import javax.ejb.Stateless;
import javax.persistence.*;

@Stateless
public class PasswordResetTokenService {

    @PersistenceContext(unitName = "com.mycompany_vizsgaremek1_war_1.0-SNAPSHOTPU")
    private EntityManager em;

    //új token
    public String createToken(Integer userId) {
        //Egyedi token generálása
        String token = UUID.randomUUID().toString();

        //Lejárati idő: 1 óra
        LocalDateTime expiresAt = LocalDateTime.now().plusHours(1);

        //Stored procedure hívása
        StoredProcedureQuery sp = em.createStoredProcedureQuery("CreatePasswordResetToken");

        sp.registerStoredProcedureParameter("p_user_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_token", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_expires_at", LocalDateTime.class, ParameterMode.IN);

        sp.setParameter("p_user_id", userId);
        sp.setParameter("p_token", token);
        sp.setParameter("p_expires_at", expiresAt);

        sp.execute();

        return token;
    }

    //token keresése
    @SuppressWarnings("unchecked")
    public PasswordResetToken findByToken(String token) {
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("GetPasswordResetToken", PasswordResetToken.class);
            sp.registerStoredProcedureParameter("p_token", String.class, ParameterMode.IN);
            sp.setParameter("p_token", token);

            List<PasswordResetToken> results = sp.getResultList();
            if (results != null && !results.isEmpty()) {
                return results.get(0);
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    //token megjelölése használtként
    public void markAsUsed(String token) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("MarkPasswordResetTokenAsUsed");
        sp.registerStoredProcedureParameter("p_token", String.class, ParameterMode.IN);
        sp.setParameter("p_token", token);
        sp.execute();
    }

    //token érvényességének ellenőrzése
    public boolean isTokenValid(String token) {
        PasswordResetToken resetToken = findByToken(token);
        if (resetToken == null) {
            return false;
        }
        // Token érvényes, ha nem járt le ÉS nem lett használva
        return !resetToken.isExpired() && !resetToken.isUsed();
    }
}

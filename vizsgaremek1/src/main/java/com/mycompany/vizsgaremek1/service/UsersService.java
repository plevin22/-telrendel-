package com.mycompany.vizsgaremek1.service;

import com.mycompany.vizsgaremek1.model.Users;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.*;
import org.mindrot.jbcrypt.BCrypt;

@Stateless
public class UsersService {

    @PersistenceContext(unitName = "com.mycompany_vizsgaremek1_war_1.0-SNAPSHOTPU")
    private EntityManager em;

    /**
     * Felhasználó keresése ID alapján.
     */
    public Users findUserById(Integer userId) {
        return em.find(Users.class, userId);
    }

    /**
     * Felhasználó keresése email alapján.
     */
    public Users findUserByEmail(String email) {
        try {
            return em.createQuery(
                "SELECT u FROM Users u WHERE u.email = :email", Users.class
            ).setParameter("email", email).getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    /**
     * Összes felhasználó lekérdezése.
     */
    @SuppressWarnings("unchecked")
    public List<Users> getAllUsers() {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("GetAllUsers", Users.class);
        return sp.getResultList();
    }

    /**
     * Új felhasználó létrehozása - CreateUser eljárás.
     */
    public void createUser(String name, String email, String password, String phone, String address, String role) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("CreateUser");
        
        sp.registerStoredProcedureParameter("p_name", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_email", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_password", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_phone", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_address", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_role", String.class, ParameterMode.IN);

        sp.setParameter("p_name", name);
        sp.setParameter("p_email", email);
        sp.setParameter("p_password", password);
        sp.setParameter("p_phone", phone);
        sp.setParameter("p_address", address);
        sp.setParameter("p_role", role);

        sp.execute();
    }

    /**
     * Felhasználó frissítése - UpdateUser eljárás.
     */
    public void updateUser(Integer userId, String name, String email, String password, 
                          String phone, String address, String role) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("UpdateUser");
        
        sp.registerStoredProcedureParameter("p_user_id", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_name", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_email", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_password", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_phone", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_address", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_role", String.class, ParameterMode.IN);

        sp.setParameter("p_user_id", userId);
        sp.setParameter("p_name", name);
        sp.setParameter("p_email", email);
        sp.setParameter("p_password", password);
        sp.setParameter("p_phone", phone);
        sp.setParameter("p_address", address);
        sp.setParameter("p_role", role);

        sp.execute();
    }

    /**
     * Felhasználó törlése - DeleteUser eljárás.
     */
    public void deleteUser(Integer userId) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("DeleteUser");
        sp.registerStoredProcedureParameter("p_user_id", Integer.class, ParameterMode.IN);
        sp.setParameter("p_user_id", userId);
        sp.execute();
    }

    /**
     * Jelszó hash-elése BCrypt-tel.
     */
    public String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
    }

    /**
     * Jelszó ellenőrzése BCrypt-tel.
     */
    public boolean checkPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}

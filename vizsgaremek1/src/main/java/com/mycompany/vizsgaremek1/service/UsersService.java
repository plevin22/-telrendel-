package com.mycompany.vizsgaremek1.service;

import com.mycompany.vizsgaremek1.model.Users;
import javax.ejb.Stateless;
import javax.persistence.*;
import org.mindrot.jbcrypt.BCrypt;

@Stateless
public class UsersService {

    @PersistenceContext(unitName = "com.mycompany_vizsgaremek1_war_1.0-SNAPSHOTPU")
    private EntityManager em;

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
     * Jelszó hashelése BCrypt algoritmussal.
     */
    public String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    /**
     * Új felhasználó létrehozása a CreateUser tárolt eljárással.
     */
    public void createUser(String name, String email, String hashedPassword, 
                          String phone, String address, String role) {
        StoredProcedureQuery sp = em.createStoredProcedureQuery("CreateUser");
        
        sp.registerStoredProcedureParameter("name", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("email", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("password", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("phone", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("address", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("role", String.class, ParameterMode.IN);

        sp.setParameter("name", name);
        sp.setParameter("email", email);
        sp.setParameter("password", hashedPassword);
        sp.setParameter("phone", phone);
        sp.setParameter("address", address);
        sp.setParameter("role", role);

        sp.execute();
    }
}
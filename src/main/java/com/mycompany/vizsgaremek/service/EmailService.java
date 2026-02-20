package com.mycompany.vizsgaremek.service;

import com.mycompany.vizsgaremek.config.JWT;
import com.mycompany.vizsgaremek.model.Users;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.ParameterMode;
import javax.persistence.PersistenceContext;
import javax.persistence.StoredProcedureQuery;
import org.json.JSONObject;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author djhob
 */
@Stateless
public class EmailService{

     static void sendEmail(String email, String sikeres_regisztráció_, String string) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    static void sendEmaill(String email, String sikeres_regisztráció_, String string) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @PersistenceContext(unitName = "com.mycompany_Vizsgaremek_war_1.0-SNAPSHOTPU")
    private EntityManager em;


   
    //  jwt login

    public JSONObject login(String email, String password) {
        JSONObject resp = new JSONObject();
        String status = "success";
        int statusCode = 200;

        try {
            Users user = em.createQuery(
                    "SELECT u FROM Users u WHERE u.email = :email", Users.class)
                    .setParameter("email", email)
                    .getSingleResult();

            if (user == null) {
                status = "NoRecordFound";
                statusCode = 200;

            } else {
                boolean ok = BCrypt.checkpw(password, user.getPasswordHash());

                if (!ok) {
                    status = "WrongPassword";
                    statusCode = 401;

                } else {
                    JSONObject result = new JSONObject();
                    result.put("id", user.getId());
                    result.put("name", user.getName());
                    result.put("email", user.getEmail());
                    result.put("phone", user.getPhone());
                    result.put("role", user.getRole());
                    result.put("jwt", JWT.createJwt(user));

                    resp.put("result", result);
                }
            }

        } catch (NoResultException e) {
            status = "NoRecordFound";
            statusCode = 200;

        } catch (Exception e) {
            e.printStackTrace();
            status = "DatabaseError";
            statusCode = 500;
        }

        resp.put("status", status);
        resp.put("statusCode", statusCode);
        return resp;
    }



   
    //  regisztracio: email, passwordhash, store procedure

    public JSONObject registerUser(String name, String email, String password,
                                   String phone, String address, String role) {

        JSONObject resp = new JSONObject();

        try {
            // 1) Email ellenőrzés
            Long exists = em.createQuery(
                    "SELECT COUNT(u.id) FROM Users u WHERE u.email = :email",
                    Long.class)
                    .setParameter("email", email)
                    .getSingleResult();

            if (exists > 0) {
                resp.put("status", "EmailExists");
                resp.put("statusCode", 409);
                return resp;
            }

            // 2) Hash-elt jelszó
            String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt(12));

            // 3) Stored procedure meghívása
            StoredProcedureQuery spq =
                    em.createStoredProcedureQuery("createUser");

            spq.registerStoredProcedureParameter("p_name", String.class, ParameterMode.IN);
            spq.registerStoredProcedureParameter("p_email", String.class, ParameterMode.IN);
            spq.registerStoredProcedureParameter("p_password_hash", String.class, ParameterMode.IN);
            spq.registerStoredProcedureParameter("p_phone", String.class, ParameterMode.IN);
            spq.registerStoredProcedureParameter("p_address", String.class, ParameterMode.IN);
            spq.registerStoredProcedureParameter("p_role", String.class, ParameterMode.IN);

            spq.setParameter("p_name", name);
            spq.setParameter("p_email", email);
            spq.setParameter("p_password_hash", passwordHash);
            spq.setParameter("p_phone", phone);
            spq.setParameter("p_address", address);
            spq.setParameter("p_role", role);

            spq.execute();

            // 4) Email küldés
            EmailService.sendEmail(
                    email,
                    "Sikeres regisztráció ✔",
                    "<h1>Üdv, " + name + "!</h1>" +
                    "<p>Sikeresen regisztráltál a Vizsgaremek rendszerbe.</p>" +
                    "<p>Szerepköröd: " + role + "</p>"
            );

            // 5) Sikeres válasz
            resp.put("status", "RegistrationSuccess");
            resp.put("statusCode", 201);
            return resp;

        } catch (Exception e) {
            e.printStackTrace();
            resp.put("status", "DatabaseError");
            resp.put("statusCode", 500);
            return resp;
        }
    }
}

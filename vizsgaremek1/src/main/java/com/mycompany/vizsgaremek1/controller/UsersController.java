package com.mycompany.vizsgaremek1.controller;

import com.mycompany.vizsgaremek1.model.Users;
import com.mycompany.vizsgaremek1.service.UsersService;
import javax.ejb.EJB;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.json.JSONObject;

@Path("users")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UsersController {

    @EJB
    private UsersService usersService;

    @POST
    @Path("/createUser")
    public Response createUser(String requestBody) {
        JSONObject response = new JSONObject();

        // Üres request body ellenőrzés
        if (requestBody == null || requestBody.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "A kérés törzse üres.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString())
                    .build();
        }

        JSONObject request;
        try {
            request = new JSONObject(requestBody);
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "Érvénytelen JSON formátum.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString())
                    .build();
        }

        // Kötelező mezők kinyerése
        String name = request.optString("name", null);
        String email = request.optString("email", null);
        String password = request.optString("password", null);
        String phone = request.optString("phone", null);
        String address = request.optString("address", null);
        String role = request.optString("role", null);

        // ==================== VALIDÁCIÓK ====================

        // Name ellenőrzés
        if (name == null || name.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "A név megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString())
                    .build();
        }

        if (name.length() > 255) {
            response.put("status", "error");
            response.put("message", "A név maximum 255 karakter lehet.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString())
                    .build();
        }

        // Email ellenőrzés
        if (email == null || email.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "Az email megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString())
                    .build();
        }

        if (email.length() > 255) {
            response.put("status", "error");
            response.put("message", "Az email maximum 255 karakter lehet.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString())
                    .build();
        }

        // Email formátum ellenőrzés
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        if (!email.matches(emailRegex)) {
            response.put("status", "error");
            response.put("message", "Érvénytelen email formátum.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString())
                    .build();
        }

        // Password ellenőrzés
        if (password == null || password.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "A jelszó megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString())
                    .build();
        }

        if (password.length() < 6) {
            response.put("status", "error");
            response.put("message", "A jelszónak minimum 6 karakter hosszúnak kell lennie.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString())
                    .build();
        }

        if (password.length() > 255) {
            response.put("status", "error");
            response.put("message", "A jelszó maximum 255 karakter lehet.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString())
                    .build();
        }

        // Phone ellenőrzés (opcionális, de ha meg van adva, legyen valid)
        if (phone != null && !phone.trim().isEmpty()) {
            if (phone.length() > 50) {
                response.put("status", "error");
                response.put("message", "A telefonszám maximum 50 karakter lehet.");
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity(response.toString())
                        .build();
            }

            String phoneRegex = "^\\+?[0-9]{6,15}$";
            if (!phone.matches(phoneRegex)) {
                response.put("status", "error");
                response.put("message", "Érvénytelen telefonszám formátum.");
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity(response.toString())
                        .build();
            }
        } else {
            phone = "";
        }

        // Address ellenőrzés (opcionális)
        if (address != null && address.length() > 255) {
            response.put("status", "error");
            response.put("message", "A cím maximum 255 karakter lehet.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString())
                    .build();
        }
        if (address == null) {
            address = "";
        }

        // Role ellenőrzés
        if (role == null || role.trim().isEmpty()) {
            role = "customer"; // Alapértelmezett szerepkör
        }

        if (!role.equals("customer") && !role.equals("admin") && !role.equals("restaurant_owner")) {
            response.put("status", "error");
            response.put("message", "Érvénytelen szerepkör. Engedélyezett értékek: customer, admin, restaurant_owner.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString())
                    .build();
        }

        // ==================== ADATBÁZIS MŰVELETEK ====================

        try {
            // Email foglaltság ellenőrzés
            if (usersService.findUserByEmail(email) != null) {
                response.put("status", "error");
                response.put("message", "Ez az email cím már foglalt.");
                return Response.status(Response.Status.CONFLICT)
                        .entity(response.toString())
                        .build();
            }

            // Jelszó hashelése
            String hashedPassword = usersService.hashPassword(password);

            // Felhasználó létrehozása
            usersService.createUser(name.trim(), email.trim(), hashedPassword, phone, address, role);

            // Létrehozott felhasználó lekérése
            Users createdUser = usersService.findUserByEmail(email);

            response.put("status", "success");
            response.put("message", "Sikeres regisztráció.");
            response.put("user_id", createdUser.getUserId());
            response.put("name", createdUser.getName());
            response.put("email", createdUser.getEmail());
            response.put("role", createdUser.getRole().toString());

            return Response.status(Response.Status.CREATED)
                    .entity(response.toString())
                    .build();

        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(response.toString())
                    .build();
        }
    }
}
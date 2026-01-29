package com.mycompany.vizsgaremek1.controller;

import com.mycompany.vizsgaremek1.model.Users;
import com.mycompany.vizsgaremek1.service.UsersService;
import java.util.List;
import javax.ejb.EJB;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.json.JSONArray;
import org.json.JSONObject;

@Path("/users")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UsersController {

    @EJB
    private UsersService usersService;

    /**
     * Jelszó validálása - minimum 8 karakter, nagybetű, speciális karakter
     */
    private String validatePassword(String password) {
        // Minimum 8 karakter
        if (password.length() < 8) {
            return "A jelszónak minimum 8 karakter hosszúnak kell lennie.";
        }
        
        // Nagybetű ellenőrzés
        boolean hasUppercase = false;
        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) {
                hasUppercase = true;
                break;
            }
        }
        if (!hasUppercase) {
            return "A jelszónak tartalmaznia kell legalább egy nagybetűt.";
        }
        
        // Speciális karakter ellenőrzés
        String specialChars = "!@#$%^&*()_+-=[]{}|;':\",./<>?`~";
        boolean hasSpecial = false;
        for (char c : password.toCharArray()) {
            if (specialChars.indexOf(c) != -1) {
                hasSpecial = true;
                break;
            }
        }
        if (!hasSpecial) {
            return "A jelszónak tartalmaznia kell legalább egy speciális karaktert.";
        }
        
        return null; // Nincs hiba, a jelszó megfelel
    }

    @GET
    @Path("/GetAllUsers")
    public Response getAllUsers() {
        try {
            List<Users> users = usersService.getAllUsers();
            JSONArray jsonArray = new JSONArray();
            for (Users user : users) {
                JSONObject userJson = new JSONObject();
                userJson.put("user_id", user.getUserId());
                userJson.put("name", user.getName());
                userJson.put("email", user.getEmail());
                userJson.put("phone", user.getPhone());
                userJson.put("address", user.getAddress());
                userJson.put("role", user.getRole().toString());
                userJson.put("created_at", user.getCreatedAt() != null ? user.getCreatedAt().toString() : null);
                jsonArray.put(userJson);
            }
            return Response.ok(jsonArray.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject response = new JSONObject();
            response.put("status", "error");
            response.put("message", "Hiba történt a lekérdezés során.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }

    @GET
    @Path("/GetUserById/{id}")
    public Response getUserById(@PathParam("id") Integer id) {
        try {
            Users user = usersService.findUserById(id);
            if (user == null) {
                JSONObject response = new JSONObject();
                response.put("status", "error");
                response.put("message", "A felhasználó nem található.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }
            JSONObject userJson = new JSONObject();
            userJson.put("user_id", user.getUserId());
            userJson.put("name", user.getName());
            userJson.put("email", user.getEmail());
            userJson.put("phone", user.getPhone());
            userJson.put("address", user.getAddress());
            userJson.put("role", user.getRole().toString());
            userJson.put("created_at", user.getCreatedAt() != null ? user.getCreatedAt().toString() : null);
            return Response.ok(userJson.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject response = new JSONObject();
            response.put("status", "error");
            response.put("message", "Hiba történt a lekérdezés során.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }

    @POST
    @Path("/CreateUser")
    public Response createUser(String requestBody) {
        JSONObject response = new JSONObject();
        if (requestBody == null || requestBody.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "A kérés törzse üres.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        JSONObject request;
        try {
            request = new JSONObject(requestBody);
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "Érvénytelen JSON formátum.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }

        String name = request.optString("name", null);
        String email = request.optString("email", null);
        String password = request.optString("password", null);
        String phone = request.optString("phone", "");
        String address = request.optString("address", "");
        String role = request.optString("role", "customer");

        // Név validáció
        if (name == null || name.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "A név megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        if (name.length() > 255) {
            response.put("status", "error");
            response.put("message", "A név maximum 255 karakter lehet.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }

        // Email validáció
        if (email == null || email.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "Az email megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        if (!email.matches(emailRegex)) {
            response.put("status", "error");
            response.put("message", "Érvénytelen email formátum.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }

        // Jelszó validáció
        if (password == null || password.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "A jelszó megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        
        // Erős jelszó ellenőrzés
        String passwordError = validatePassword(password);
        if (passwordError != null) {
            response.put("status", "error");
            response.put("message", passwordError);
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }

        // Szerepkör validáció
        if (!role.equals("customer") && !role.equals("admin") && !role.equals("restaurant_owner")) {
            response.put("status", "error");
            response.put("message", "Érvénytelen szerepkör. Engedélyezett: customer, admin, restaurant_owner.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }

        try {
            // Email egyediség ellenőrzése
            if (usersService.findUserByEmail(email) != null) {
                response.put("status", "error");
                response.put("message", "Ez az email cím már foglalt.");
                return Response.status(Response.Status.CONFLICT).entity(response.toString()).build();
            }
            
            // Jelszó hash-elése és felhasználó létrehozása
            String hashedPassword = usersService.hashPassword(password);
            usersService.createUser(name.trim(), email.trim(), hashedPassword, phone, address, role);
            
            Users createdUser = usersService.findUserByEmail(email);
            response.put("status", "success");
            response.put("message", "Sikeres regisztráció.");
            response.put("user_id", createdUser.getUserId());
            response.put("name", createdUser.getName());
            response.put("email", createdUser.getEmail());
            response.put("role", createdUser.getRole().toString());
            return Response.status(Response.Status.CREATED).entity(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }

    @POST
    @Path("/Login")
    public Response login(String requestBody) {
        JSONObject response = new JSONObject();
        if (requestBody == null || requestBody.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "A kérés törzse üres.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        JSONObject request;
        try {
            request = new JSONObject(requestBody);
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "Érvénytelen JSON formátum.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }

        String email = request.optString("email", null);
        String password = request.optString("password", null);

        if (email == null || email.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "Az email megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        if (password == null || password.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "A jelszó megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }

        try {
            Users user = usersService.findUserByEmail(email);
            if (user == null) {
                response.put("status", "error");
                response.put("message", "Felhasználó nem található.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }
            if (!usersService.checkPassword(password, user.getPassword())) {
                response.put("status", "error");
                response.put("message", "Hibás jelszó.");
                return Response.status(Response.Status.UNAUTHORIZED).entity(response.toString()).build();
            }
            response.put("status", "success");
            response.put("message", "Sikeres bejelentkezés.");
            response.put("user_id", user.getUserId());
            response.put("name", user.getName());
            response.put("email", user.getEmail());
            response.put("role", user.getRole().toString());
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Hiba történt a bejelentkezés során.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }

    @PUT
    @Path("/UpdateUser/{id}")
    public Response updateUser(@PathParam("id") Integer id, String requestBody) {
        JSONObject response = new JSONObject();
        if (requestBody == null || requestBody.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "A kérés törzse üres.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        JSONObject request;
        try {
            request = new JSONObject(requestBody);
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "Érvénytelen JSON formátum.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        try {
            Users existing = usersService.findUserById(id);
            if (existing == null) {
                response.put("status", "error");
                response.put("message", "A felhasználó nem található.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }
            
            String name = request.optString("name", existing.getName());
            String email = request.optString("email", existing.getEmail());
            String phone = request.optString("phone", existing.getPhone());
            String address = request.optString("address", existing.getAddress());
            String role = request.optString("role", existing.getRole().toString());
            
            // Jelszó frissítés - csak ha meg van adva új jelszó
            String password = existing.getPassword();
            if (request.has("password") && !request.getString("password").isEmpty()) {
                String newPassword = request.getString("password");
                
                // Erős jelszó ellenőrzés az új jelszóra is
                String passwordError = validatePassword(newPassword);
                if (passwordError != null) {
                    response.put("status", "error");
                    response.put("message", passwordError);
                    return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
                }
                
                password = usersService.hashPassword(newPassword);
            }

            if (!role.equals("customer") && !role.equals("admin") && !role.equals("restaurant_owner")) {
                response.put("status", "error");
                response.put("message", "Érvénytelen szerepkör.");
                return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
            }
            
            usersService.updateUser(id, name, email, password, phone, address, role);
            response.put("status", "success");
            response.put("message", "A felhasználó sikeresen frissítve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }

    @DELETE
    @Path("/DeleteUser/{id}")
    public Response deleteUser(@PathParam("id") Integer id) {
        JSONObject response = new JSONObject();
        try {
            Users user = usersService.findUserById(id);
            if (user == null) {
                response.put("status", "error");
                response.put("message", "A felhasználó nem található.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }
            usersService.deleteUser(id);
            response.put("status", "success");
            response.put("message", "A felhasználó sikeresen törölve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }
}
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
        if (password.length() < 8) {
            return "A jelszónak minimum 8 karakter hosszúnak kell lennie.";
        }
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
        return null;
    }

    private JSONObject userToJson(Users user) {
        JSONObject json = new JSONObject();
        json.put("user_id", user.getUserId());
        json.put("name", user.getName());
        json.put("username", user.getUsername());
        json.put("email", user.getEmail());
        json.put("phone", user.getPhone());
        json.put("role", user.getRole().toString());
        json.put("created_at", user.getCreatedAt() != null ? user.getCreatedAt().toString() : null);
        return json;
    }

    private Response errorResponse(String message, Response.Status status) {
        JSONObject response = new JSONObject();
        response.put("status", "error");
        response.put("message", message);
        return Response.status(status).entity(response.toString()).build();
    }

    @GET
    @Path("/GetAllUsers")
    public Response getAllUsers() {
        try {
            List<Users> users = usersService.getAllUsers();
            JSONArray jsonArray = new JSONArray();
            for (Users user : users) {
                jsonArray.put(userToJson(user));
            }
            return Response.ok(jsonArray.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Hiba történt a lekérdezés során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @GET
    @Path("/GetUserById/{id}")
    public Response getUserById(@PathParam("id") Integer id) {
        try {
            Users user = usersService.findUserById(id);
            if (user == null) {
                return errorResponse("A felhasználó nem található.", Response.Status.NOT_FOUND);
            }
            return Response.ok(userToJson(user).toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Hiba történt a lekérdezés során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @POST
    @Path("/CreateUser")
    public Response createUser(String requestBody) {
        if (requestBody == null || requestBody.trim().isEmpty()) {
            return errorResponse("A kérés törzse üres.", Response.Status.BAD_REQUEST);
        }
        JSONObject request;
        try {
            request = new JSONObject(requestBody);
        } catch (Exception e) {
            return errorResponse("Érvénytelen JSON formátum.", Response.Status.BAD_REQUEST);
        }

        String name = request.optString("name", null);
        String username = request.optString("username", null);
        String email = request.optString("email", null);
        String password = request.optString("password", null);
        String phone = request.optString("phone", "");
        String role = request.optString("role", "customer");

        // Név validáció
        if (name == null || name.trim().isEmpty()) {
            return errorResponse("A név megadása kötelező.", Response.Status.BAD_REQUEST);
        }
        if (name.length() > 255) {
            return errorResponse("A név maximum 255 karakter lehet.", Response.Status.BAD_REQUEST);
        }

        // Username validáció
        if (username == null || username.trim().isEmpty()) {
            return errorResponse("A felhasználónév megadása kötelező.", Response.Status.BAD_REQUEST);
        }
        if (username.length() > 255) {
            return errorResponse("A felhasználónév maximum 255 karakter lehet.", Response.Status.BAD_REQUEST);
        }

        // Email validáció
        if (email == null || email.trim().isEmpty()) {
            return errorResponse("Az email megadása kötelező.", Response.Status.BAD_REQUEST);
        }
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        if (!email.matches(emailRegex)) {
            return errorResponse("Érvénytelen email formátum.", Response.Status.BAD_REQUEST);
        }

        // Jelszó validáció
        if (password == null || password.trim().isEmpty()) {
            return errorResponse("A jelszó megadása kötelező.", Response.Status.BAD_REQUEST);
        }
        String passwordError = validatePassword(password);
        if (passwordError != null) {
            return errorResponse(passwordError, Response.Status.BAD_REQUEST);
        }

        // Role validáció
        if (!role.equals("customer") && !role.equals("admin") && !role.equals("restaurant_owner")) {
            return errorResponse("Érvénytelen szerepkör.", Response.Status.BAD_REQUEST);
        }

        try {
            // Email egyediség ellenőrzése
            if (usersService.emailExists(email)) {
                return errorResponse("Ez az email cím már foglalt.", Response.Status.CONFLICT);
            }
            // Username egyediség ellenőrzése
            if (usersService.usernameExists(username)) {
                return errorResponse("Ez a felhasználónév már foglalt.", Response.Status.CONFLICT);
            }
            
            String hashedPassword = usersService.hashPassword(password);
            usersService.createUser(name.trim(), username.trim(), email.trim(), hashedPassword, phone, role);
            
            Users createdUser = usersService.findUserByEmail(email);
            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("message", "Sikeres regisztráció.");
            response.put("user_id", createdUser.getUserId());
            response.put("name", createdUser.getName());
            response.put("username", createdUser.getUsername());
            response.put("email", createdUser.getEmail());
            response.put("role", createdUser.getRole().toString());
            return Response.status(Response.Status.CREATED).entity(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Adatbázis hiba történt.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @POST
    @Path("/Login")
    public Response login(String requestBody) {
        if (requestBody == null || requestBody.trim().isEmpty()) {
            return errorResponse("A kérés törzse üres.", Response.Status.BAD_REQUEST);
        }
        JSONObject request;
        try {
            request = new JSONObject(requestBody);
        } catch (Exception e) {
            return errorResponse("Érvénytelen JSON formátum.", Response.Status.BAD_REQUEST);
        }

        String email = request.optString("email", null);
        String password = request.optString("password", null);

        if (email == null || email.trim().isEmpty()) {
            return errorResponse("Az email megadása kötelező.", Response.Status.BAD_REQUEST);
        }
        if (password == null || password.trim().isEmpty()) {
            return errorResponse("A jelszó megadása kötelező.", Response.Status.BAD_REQUEST);
        }

        try {
            Users user = usersService.findUserByEmail(email);
            if (user == null) {
                return errorResponse("Felhasználó nem található.", Response.Status.NOT_FOUND);
            }
            
            // BCrypt ellenőrzés, fallback plain text-re (régi jelszavakhoz)
            boolean passwordMatch = false;
            try {
                passwordMatch = usersService.checkPassword(password, user.getPassword());
            } catch (Exception e) {
                // Ha nem BCrypt hash, akkor plain text összehasonlítás
                passwordMatch = password.equals(user.getPassword());
            }
            
            if (!passwordMatch) {
                return errorResponse("Hibás jelszó.", Response.Status.UNAUTHORIZED);
            }
            
            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("message", "Sikeres bejelentkezés.");
            response.put("user_id", user.getUserId());
            response.put("name", user.getName());
            response.put("username", user.getUsername());
            response.put("email", user.getEmail());
            response.put("role", user.getRole().toString());
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Hiba történt a bejelentkezés során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @PUT
    @Path("/UpdateUser/{id}")
    public Response updateUser(@PathParam("id") Integer id, String requestBody) {
        if (requestBody == null || requestBody.trim().isEmpty()) {
            return errorResponse("A kérés törzse üres.", Response.Status.BAD_REQUEST);
        }
        JSONObject request;
        try {
            request = new JSONObject(requestBody);
        } catch (Exception e) {
            return errorResponse("Érvénytelen JSON formátum.", Response.Status.BAD_REQUEST);
        }
        
        try {
            Users existing = usersService.findUserById(id);
            if (existing == null) {
                return errorResponse("A felhasználó nem található.", Response.Status.NOT_FOUND);
            }
            
            String name = request.optString("name", existing.getName());
            String username = request.optString("username", existing.getUsername());
            String email = request.optString("email", existing.getEmail());
            String phone = request.optString("phone", existing.getPhone());
            String role = request.optString("role", existing.getRole().toString());
            
            // Username egyediség ellenőrzése (ha változott)
            if (!username.equals(existing.getUsername()) && usersService.usernameExists(username)) {
                return errorResponse("Ez a felhasználónév már foglalt.", Response.Status.CONFLICT);
            }
            
            // Email egyediség ellenőrzése (ha változott)
            if (!email.equals(existing.getEmail()) && usersService.emailExists(email)) {
                return errorResponse("Ez az email cím már foglalt.", Response.Status.CONFLICT);
            }
            
            // Jelszó frissítés - csak ha meg van adva új jelszó
            String password = existing.getPassword();
            if (request.has("password") && !request.optString("password", "").isEmpty()) {
                String newPassword = request.getString("password");
                String passwordError = validatePassword(newPassword);
                if (passwordError != null) {
                    return errorResponse(passwordError, Response.Status.BAD_REQUEST);
                }
                password = usersService.hashPassword(newPassword);
            }

            if (!role.equals("customer") && !role.equals("admin") && !role.equals("restaurant_owner")) {
                return errorResponse("Érvénytelen szerepkör.", Response.Status.BAD_REQUEST);
            }
            
            usersService.updateUser(id, name, username, email, password, phone, role);
            
            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("message", "A felhasználó sikeresen frissítve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Adatbázis hiba történt.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @DELETE
    @Path("/DeleteUser/{id}")
    public Response deleteUser(@PathParam("id") Integer id) {
        try {
            Users user = usersService.findUserById(id);
            if (user == null) {
                return errorResponse("A felhasználó nem található.", Response.Status.NOT_FOUND);
            }
            usersService.deleteUser(id);
            
            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("message", "A felhasználó sikeresen törölve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Adatbázis hiba történt.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }
}

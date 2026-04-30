package com.mycompany.vizsgaremek1.controller;

import com.mycompany.vizsgaremek1.model.PasswordResetToken;
import com.mycompany.vizsgaremek1.model.Users;
import com.mycompany.vizsgaremek1.service.EmailService;
import com.mycompany.vizsgaremek1.service.PasswordResetTokenService;
import com.mycompany.vizsgaremek1.service.UsersService;
import javax.ejb.EJB;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.json.JSONObject;

@Path("/password")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PasswordResetTokenController {

    @EJB
    private UsersService usersService;

    @EJB
    private PasswordResetTokenService tokenService;

    @EJB
    private EmailService emailService;

    private Response errorResponse(String message, Response.Status status) {
        JSONObject response = new JSONObject();
        response.put("status", "error");
        response.put("message", message);
        return Response.status(status).entity(response.toString()).build();
    }

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

    @POST
    @Path("/ForgotUserPassword")
    public Response forgotPassword(String requestBody) {
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

        if (email == null || email.trim().isEmpty()) {
            return errorResponse("Az email cím megadása kötelező.", Response.Status.BAD_REQUEST);
        }

        try {
            //Felhasználó keresése email alapján
            Users user = usersService.findUserByEmail(email.trim());

            //Biztonsági okokból mindig sikeres választ adunk (ne lehessen kideríteni, hogy létezik-e az email)
            if (user == null) {
                JSONObject response = new JSONObject();
                response.put("status", "success");
                response.put("message", "Ha az email cím létezik a rendszerben, hamarosan kapsz egy visszaállító linket.");
                return Response.ok(response.toString()).build();
            }

            //Token generálása és mentése
            String token = tokenService.createToken(user.getUserId());

            //Email küldése
            try {
                emailService.sendPasswordResetEmail(user.getEmail(), user.getName(), token);
            } catch (Exception emailEx) {
                System.err.println("Jelszó visszaállítás email küldési hiba: " + emailEx.getMessage());
            }

            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("message", "Ha az email cím létezik a rendszerben, hamarosan kapsz egy visszaállító linket.");
            return Response.ok(response.toString()).build();

        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Hiba történt a feldolgozás során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @POST
    @Path("/ResetUserPassword")
    public Response resetPassword(String requestBody) {
        if (requestBody == null || requestBody.trim().isEmpty()) {
            return errorResponse("A kérés törzse üres.", Response.Status.BAD_REQUEST);
        }

        JSONObject request;
        try {
            request = new JSONObject(requestBody);
        } catch (Exception e) {
            return errorResponse("Érvénytelen JSON formátum.", Response.Status.BAD_REQUEST);
        }

        String token = request.optString("token", null);
        String newPassword = request.optString("new_password", null);

        if (token == null || token.trim().isEmpty()) {
            return errorResponse("A token megadása kötelező.", Response.Status.BAD_REQUEST);
        }

        if (newPassword == null || newPassword.trim().isEmpty()) {
            return errorResponse("Az új jelszó megadása kötelező.", Response.Status.BAD_REQUEST);
        }

        //Jelszó validálása
        String passwordError = validatePassword(newPassword);
        if (passwordError != null) {
            return errorResponse(passwordError, Response.Status.BAD_REQUEST);
        }

        try {
            //Token keresése és ellenőrzése
            PasswordResetToken resetToken = tokenService.findByToken(token.trim());

            if (resetToken == null) {
                return errorResponse("Érvénytelen vagy lejárt token.", Response.Status.BAD_REQUEST);
            }

            if (resetToken.isExpired()) {
                return errorResponse("A token lejárt. Kérj új visszaállító linket.", Response.Status.BAD_REQUEST);
            }

            if (resetToken.isUsed()) {
                return errorResponse("Ez a token már fel lett használva.", Response.Status.BAD_REQUEST);
            }

            //Felhasználó keresése
            Users user = usersService.findUserById(resetToken.getUserId());
            if (user == null) {
                return errorResponse("A felhasználó nem található.", Response.Status.NOT_FOUND);
            }

            //Új jelszó hashelése és mentése
            String hashedPassword = usersService.hashPassword(newPassword);
            usersService.changeUserPassword(user.getUserId(), hashedPassword);

            //Token megjelölése használtként
            tokenService.markAsUsed(token.trim());

            //Értesítő email küldése
            try {
                emailService.sendPasswordChangedEmail(user.getEmail(), user.getName());
            } catch (Exception emailEx) {
                System.err.println("Jelszó változtatás email küldési hiba: " + emailEx.getMessage());
            }

            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("message", "A jelszó sikeresen megváltozott.");
            return Response.ok(response.toString()).build();

        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Hiba történt a jelszó visszaállítása során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @GET
    @Path("/ValidateToken/{token}")
    public Response validateToken(@PathParam("token") String token) {
        try {
            boolean isValid = tokenService.isTokenValid(token);

            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("valid", isValid);

            if (!isValid) {
                response.put("message", "A token érvénytelen vagy lejárt.");
            }

            return Response.ok(response.toString()).build();

        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Hiba történt a token ellenőrzése során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }
}

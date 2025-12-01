package com.mycompany.Vizsgaremek.controller;

import com.mycompany.vizsgaremek.service.UsersService;
import javax.inject.Inject;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.json.JSONObject;

@Path("Users")
public class UsersController {

    @Inject
    private UsersService usersService;

    @POST
    @Path("createUser")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response createUser(String body) {
        JSONObject obj = new JSONObject(body);

        String name = obj.getString("name");
        String email = obj.getString("email");
        String passwordHash = obj.getString("passwordHash");
        String phone = obj.getString("phone");
        String address = obj.getString("address");
        String role = obj.getString("role");

        JSONObject result = usersService.createUser(
            name, email, passwordHash, phone, address, role
        );

        return Response
                .status(result.getInt("statusCode"))
                .entity(result.toString())
                .type(MediaType.APPLICATION_JSON)
                .build();
    }
}

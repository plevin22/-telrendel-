package com.mycompany.vizsgaremek1.controller;

import com.mycompany.vizsgaremek1.model.Restaurants;
import com.mycompany.vizsgaremek1.service.RestaurantsService;
import java.util.List;
import javax.ejb.EJB;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.json.JSONArray;
import org.json.JSONObject;

@Path("/restaurants")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class RestaurantsController {

    @EJB
    private RestaurantsService restaurantsService;

    private JSONObject restaurantToJson(Restaurants r) {
        JSONObject json = new JSONObject();
        json.put("restaurant_id", r.getRestaurantId());
        json.put("owner_id", r.getOwnerId());
        json.put("name", r.getName());
        json.put("description", r.getDescription());
        json.put("address", r.getAddress());
        json.put("phone", r.getPhone());
        json.put("open_hours", r.getOpenHours());
        json.put("image_path", r.getImagePath());
        json.put("created_at", r.getCreatedAt() != null ? r.getCreatedAt().toString() : null);
        return json;
    }

    private Response errorResponse(String message, Response.Status status) {
        JSONObject response = new JSONObject();
        response.put("status", "error");
        response.put("message", message);
        return Response.status(status).entity(response.toString()).build();
    }

    @GET
    @Path("/GetAllRestaurants")
    public Response getAllRestaurants() {
        try {
            List<Restaurants> restaurants = restaurantsService.getAllRestaurants();
            JSONArray jsonArray = new JSONArray();
            for (Restaurants r : restaurants) {
                jsonArray.put(restaurantToJson(r));
            }
            return Response.ok(jsonArray.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Hiba történt a lekérdezés során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @GET
    @Path("/GetRestaurantById/{id}")
    public Response getRestaurantById(@PathParam("id") Integer id) {
        try {
            Restaurants r = restaurantsService.findRestaurantById(id);
            if (r == null) {
                return errorResponse("Az étterem nem található.", Response.Status.NOT_FOUND);
            }
            return Response.ok(restaurantToJson(r).toString()).build();
        } catch (Exception e) {
            return errorResponse("Hiba történt a lekérdezés során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @GET
    @Path("/SearchRestaurantsByAddress/{address}")
    public Response searchRestaurantsByAddress(@PathParam("address") String address) {
        try {
            List<Restaurants> restaurants = restaurantsService.searchRestaurantsByAddress(address);
            JSONArray jsonArray = new JSONArray();
            for (Restaurants r : restaurants) {
                jsonArray.put(restaurantToJson(r));
            }
            return Response.ok(jsonArray.toString()).build();
        } catch (Exception e) {
            return errorResponse("Hiba történt a keresés során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @POST
    @Path("/AddRestaurant")
    public Response addRestaurant(String requestBody) {
        if (requestBody == null || requestBody.trim().isEmpty()) {
            return errorResponse("A kérés törzse üres.", Response.Status.BAD_REQUEST);
        }
        JSONObject request;
        try {
            request = new JSONObject(requestBody);
        } catch (Exception e) {
            return errorResponse("Érvénytelen JSON formátum.", Response.Status.BAD_REQUEST);
        }

        Integer ownerId = request.optInt("owner_id", 0);
        String name = request.optString("name", null);
        String description = request.optString("description", null);
        String address = request.optString("address", null);
        String phone = request.optString("phone", null);
        String openHours = request.optString("open_hours", null);

        if (ownerId == 0) {
            return errorResponse("Az owner_id megadása kötelező.", Response.Status.BAD_REQUEST);
        }
        if (name == null || name.trim().isEmpty()) {
            return errorResponse("Az étterem neve kötelező.", Response.Status.BAD_REQUEST);
        }

        try {
            if (!restaurantsService.ownerExists(ownerId)) {
                return errorResponse("A megadott tulajdonos nem létezik.", Response.Status.BAD_REQUEST);
            }

            restaurantsService.addRestaurant(ownerId, name, description, address, phone, openHours);

            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("message", "Az étterem sikeresen létrehozva.");
            return Response.status(Response.Status.CREATED).entity(response.toString()).build();
        } catch (Exception e) {
            return errorResponse("Adatbázis hiba történt.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @PUT
    @Path("/UpdateRestaurant/{id}")
    public Response updateRestaurant(@PathParam("id") Integer id, String requestBody) {
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
            Restaurants existing = restaurantsService.findRestaurantById(id);
            if (existing == null) {
                return errorResponse("Az étterem nem található.", Response.Status.NOT_FOUND);
            }

            String name = request.optString("name", existing.getName());
            String description = request.optString("description", existing.getDescription());
            String address = request.optString("address", existing.getAddress());
            String phone = request.optString("phone", existing.getPhone());
            String openHours = request.optString("open_hours", existing.getOpenHours());

            restaurantsService.updateRestaurant(id, name, description, address, phone, openHours);

            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("message", "Az étterem sikeresen frissítve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            return errorResponse("Adatbázis hiba történt.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @DELETE
    @Path("/DeleteRestaurant/{id}")
    public Response deleteRestaurant(@PathParam("id") Integer id) {
        try {
            Restaurants r = restaurantsService.findRestaurantById(id);
            if (r == null) {
                return errorResponse("Az étterem nem található.", Response.Status.NOT_FOUND);
            }
            restaurantsService.deleteRestaurant(id);

            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("message", "Az étterem sikeresen törölve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            return errorResponse("Adatbázis hiba történt.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }
}

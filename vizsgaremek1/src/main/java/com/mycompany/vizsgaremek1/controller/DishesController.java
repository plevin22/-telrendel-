package com.mycompany.vizsgaremek1.controller;

import com.mycompany.vizsgaremek1.model.Dishes;
import com.mycompany.vizsgaremek1.service.DishesService;
import java.math.BigDecimal;
import java.util.List;
import javax.ejb.EJB;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.json.JSONArray;
import org.json.JSONObject;

@Path("/dishes")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class DishesController {

    @EJB
    private DishesService dishesService;

    @GET
    @Path("/GetAllDishes")
    public Response getAllDishes() {
        try {
            List<Dishes> dishes = dishesService.getAllDishes();
            JSONArray jsonArray = new JSONArray();
            for (Dishes d : dishes) {
                JSONObject json = new JSONObject();
                json.put("dish_id", d.getDishId());
                json.put("restaurant_id", d.getRestaurantId());
                json.put("name", d.getName());
                json.put("description", d.getDescription());
                json.put("price", d.getPrice());
                json.put("image_url", d.getImageUrl());
                json.put("available", d.getAvailable());
                jsonArray.put(json);
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
    @Path("/GetDishById/{id}")
    public Response getDishById(@PathParam("id") Integer id) {
        try {
            Dishes d = dishesService.findDishById(id);
            if (d == null) {
                JSONObject response = new JSONObject();
                response.put("status", "error");
                response.put("message", "Az étel nem található.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }
            JSONObject json = new JSONObject();
            json.put("dish_id", d.getDishId());
            json.put("restaurant_id", d.getRestaurantId());
            json.put("name", d.getName());
            json.put("description", d.getDescription());
            json.put("price", d.getPrice());
            json.put("image_url", d.getImageUrl());
            json.put("available", d.getAvailable());
            return Response.ok(json.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject response = new JSONObject();
            response.put("status", "error");
            response.put("message", "Hiba történt a lekérdezés során.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }

    @GET
    @Path("/GetDishesByRestaurant/{restaurantId}")
    public Response getDishesByRestaurant(@PathParam("restaurantId") Integer restaurantId) {
        try {
            List<Dishes> dishes = dishesService.getDishesByRestaurantId(restaurantId);
            JSONArray jsonArray = new JSONArray();
            for (Dishes d : dishes) {
                JSONObject json = new JSONObject();
                json.put("dish_id", d.getDishId());
                json.put("restaurant_id", d.getRestaurantId());
                json.put("name", d.getName());
                json.put("description", d.getDescription());
                json.put("price", d.getPrice());
                json.put("image_url", d.getImageUrl());
                json.put("available", d.getAvailable());
                jsonArray.put(json);
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

    @POST
    @Path("/AddDish")
    public Response addDish(String requestBody) {
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

        Integer restaurantId = request.optInt("restaurant_id", 0);
        String name = request.optString("name", null);
        String description = request.optString("description", "");
        BigDecimal price = request.has("price") ? request.getBigDecimal("price") : null;
        String imageUrl = request.optString("image_url", null);
        Boolean available = request.optBoolean("available", true);

        if (restaurantId == 0) {
            response.put("status", "error");
            response.put("message", "A restaurant_id megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        if (name == null || name.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "A név megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        if (price == null || price.compareTo(BigDecimal.ZERO) <= 0) {
            response.put("status", "error");
            response.put("message", "Az árnak pozitív számnak kell lennie.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }

        try {
            if (!dishesService.restaurantExists(restaurantId)) {
                response.put("status", "error");
                response.put("message", "A megadott étterem nem létezik.");
                return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
            }
            dishesService.addDish(restaurantId, name.trim(), description, price, imageUrl, available);
            response.put("status", "success");
            response.put("message", "Az étel sikeresen létrehozva.");
            return Response.status(Response.Status.CREATED).entity(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }

    @PUT
    @Path("/UpdateDish/{id}")
    public Response updateDish(@PathParam("id") Integer id, String requestBody) {
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
            Dishes existing = dishesService.findDishById(id);
            if (existing == null) {
                response.put("status", "error");
                response.put("message", "Az étel nem található.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }

            String name = request.optString("name", existing.getName());
            String description = request.optString("description", existing.getDescription());
            BigDecimal price = request.has("price") ? request.getBigDecimal("price") : existing.getPrice();
            String imageUrl = request.optString("image_url", existing.getImageUrl());
            Boolean available = request.has("available") ? request.getBoolean("available") : existing.getAvailable();

            dishesService.updateDish(id, name, description, price, imageUrl, available);
            response.put("status", "success");
            response.put("message", "Az étel sikeresen frissítve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }

    @DELETE
    @Path("/DeleteDish/{id}")
    public Response deleteDish(@PathParam("id") Integer id) {
        JSONObject response = new JSONObject();
        try {
            Dishes d = dishesService.findDishById(id);
            if (d == null) {
                response.put("status", "error");
                response.put("message", "Az étel nem található.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }
            dishesService.deleteDish(id);
            response.put("status", "success");
            response.put("message", "Az étel sikeresen törölve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }
}

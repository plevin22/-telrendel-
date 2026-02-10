package com.mycompany.vizsgaremek1.controller;

import com.mycompany.vizsgaremek1.model.Orders;
import com.mycompany.vizsgaremek1.service.OrdersService;
import java.math.BigDecimal;
import java.util.List;
import javax.ejb.EJB;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.json.JSONArray;
import org.json.JSONObject;

@Path("/orders")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class OrdersController {

    @EJB
    private OrdersService ordersService;

    // GET http://localhost:8080/vizsgaremek1/webresources/orders/GetAllOrders
    @GET
    @Path("/GetAllOrders")
    public Response getAllOrders() {
        try {
            List<Orders> orders = ordersService.getAllOrders();
            JSONArray jsonArray = new JSONArray();

            for (Orders order : orders) {
                JSONObject orderJson = new JSONObject();
                orderJson.put("order_id", order.getOrderId());
                orderJson.put("user_id", order.getUserId());
                orderJson.put("restaurant_id", order.getRestaurantId());
                orderJson.put("status", order.getStatus().toString());
                orderJson.put("total_price", order.getTotalPrice());
                orderJson.put("created_at", order.getCreatedAt() != null ? order.getCreatedAt().toString() : null);
                jsonArray.put(orderJson);
            }

            return Response.ok(jsonArray.toString()).build();

        } catch (Exception e) {
            e.printStackTrace();
            JSONObject response = new JSONObject();
            response.put("status", "error");
            response.put("message", "Hiba történt a lekérdezés során.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(response.toString()).build();
        }
    }

    // GET http://localhost:8080/vizsgaremek1/webresources/orders/GetOrderById/{id}
    @GET
    @Path("/GetOrderById/{id}")
    public Response getOrderById(@PathParam("id") Integer id) {
        try {
            Orders order = ordersService.findOrderById(id);

            if (order == null) {
                JSONObject response = new JSONObject();
                response.put("status", "error");
                response.put("message", "A rendelés nem található.");
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(response.toString()).build();
            }

            JSONObject orderJson = new JSONObject();
            orderJson.put("order_id", order.getOrderId());
            orderJson.put("user_id", order.getUserId());
            orderJson.put("restaurant_id", order.getRestaurantId());
            orderJson.put("status", order.getStatus().toString());
            orderJson.put("total_price", order.getTotalPrice());
            orderJson.put("created_at", order.getCreatedAt() != null ? order.getCreatedAt().toString() : null);

            return Response.ok(orderJson.toString()).build();

        } catch (Exception e) {
            e.printStackTrace();
            JSONObject response = new JSONObject();
            response.put("status", "error");
            response.put("message", "Hiba történt a lekérdezés során.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(response.toString()).build();
        }
    }

    // GET http://localhost:8080/vizsgaremek1/webresources/orders/GetOrdersByUser/{userId}
    @GET
    @Path("/GetOrdersByUser/{userId}")
    public Response getOrdersByUser(@PathParam("userId") Integer userId) {
        try {
            List<Orders> orders = ordersService.getOrdersByUserId(userId);
            JSONArray jsonArray = new JSONArray();

            for (Orders order : orders) {
                JSONObject orderJson = new JSONObject();
                orderJson.put("order_id", order.getOrderId());
                orderJson.put("user_id", order.getUserId());
                orderJson.put("restaurant_id", order.getRestaurantId());
                orderJson.put("status", order.getStatus().toString());
                orderJson.put("total_price", order.getTotalPrice());
                orderJson.put("created_at", order.getCreatedAt() != null ? order.getCreatedAt().toString() : null);
                jsonArray.put(orderJson);
            }

            return Response.ok(jsonArray.toString()).build();

        } catch (Exception e) {
            e.printStackTrace();
            JSONObject response = new JSONObject();
            response.put("status", "error");
            response.put("message", "Hiba történt a lekérdezés során.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(response.toString()).build();
        }
    }

    // POST http://localhost:8080/vizsgaremek1/webresources/orders/AddOrder
    @POST
    @Path("/AddOrder")
    public Response addOrder(String requestBody) {
        JSONObject response = new JSONObject();

        if (requestBody == null || requestBody.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "A kérés törzse üres.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString()).build();
        }

        JSONObject request;
        try {
            request = new JSONObject(requestBody);
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "Érvénytelen JSON formátum.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString()).build();
        }

        Integer userId = request.has("user_id") ? request.getInt("user_id") : null;
        Integer restaurantId = request.has("restaurant_id") ? request.getInt("restaurant_id") : null;
        String deliveryAddress = request.optString("delivery_address", "Nincs megadva");
        String status = request.optString("status", "pending");
        BigDecimal totalPrice = request.has("total_price") ? request.getBigDecimal("total_price") : null;

        if (userId == null) {
            response.put("status", "error");
            response.put("message", "A felhasználó ID megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString()).build();
        }

        if (restaurantId == null) {
            response.put("status", "error");
            response.put("message", "Az étterem ID megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString()).build();
        }

        if (totalPrice == null) {
            response.put("status", "error");
            response.put("message", "A végösszeg megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString()).build();
        }

        if (totalPrice.compareTo(BigDecimal.ZERO) < 0) {
            response.put("status", "error");
            response.put("message", "A végösszeg nem lehet negatív.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString()).build();
        }

        if (!status.equals("pending") && !status.equals("preparing") && 
            !status.equals("delivering") && !status.equals("completed") && !status.equals("cancelled")) {
            response.put("status", "error");
            response.put("message", "Érvénytelen státusz. Engedélyezett értékek: pending, preparing, delivering, completed, cancelled.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString()).build();
        }

        try {
            if (!ordersService.userExists(userId)) {
                response.put("status", "error");
                response.put("message", "A megadott felhasználó nem létezik.");
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(response.toString()).build();
            }

            if (!ordersService.restaurantExists(restaurantId)) {
                response.put("status", "error");
                response.put("message", "A megadott étterem nem létezik.");
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(response.toString()).build();
            }

            // JAVÍTVA: delivery_address paraméter hozzáadva!
            ordersService.addOrder(userId, restaurantId, deliveryAddress, status, totalPrice);

            Orders createdOrder = ordersService.getLastOrderByUserAndRestaurant(userId, restaurantId);

            response.put("status", "success");
            response.put("message", "A rendelés sikeresen létrehozva.");
            if (createdOrder != null) {
                response.put("order_id", createdOrder.getOrderId());
            }

            return Response.status(Response.Status.CREATED)
                    .entity(response.toString()).build();

        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(response.toString()).build();
        }
    }

    // PUT http://localhost:8080/vizsgaremek1/webresources/orders/UpdateOrder/{id}
    @PUT
    @Path("/UpdateOrder/{id}")
    public Response updateOrder(@PathParam("id") Integer id, String requestBody) {
        JSONObject response = new JSONObject();

        if (requestBody == null || requestBody.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "A kérés törzse üres.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString()).build();
        }

        JSONObject request;
        try {
            request = new JSONObject(requestBody);
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "Érvénytelen JSON formátum.");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(response.toString()).build();
        }

        try {
            Orders existingOrder = ordersService.findOrderById(id);

            if (existingOrder == null) {
                response.put("status", "error");
                response.put("message", "A rendelés nem található.");
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(response.toString()).build();
            }

            String status = request.optString("status", existingOrder.getStatus().toString());
            BigDecimal totalPrice = request.has("total_price") ? 
                    request.getBigDecimal("total_price") : existingOrder.getTotalPrice();

            if (!status.equals("pending") && !status.equals("preparing") && 
                !status.equals("delivering") && !status.equals("completed") && !status.equals("cancelled")) {
                response.put("status", "error");
                response.put("message", "Érvénytelen státusz.");
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity(response.toString()).build();
            }

            if (totalPrice.compareTo(BigDecimal.ZERO) < 0) {
                response.put("status", "error");
                response.put("message", "A végösszeg nem lehet negatív.");
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity(response.toString()).build();
            }

            ordersService.updateOrder(id, status, totalPrice);

            response.put("status", "success");
            response.put("message", "A rendelés sikeresen frissítve.");

            return Response.ok(response.toString()).build();

        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(response.toString()).build();
        }
    }

    // DELETE http://localhost:8080/vizsgaremek1/webresources/orders/DeleteOrder/{id}
    @DELETE
    @Path("/DeleteOrder/{id}")
    public Response deleteOrder(@PathParam("id") Integer id) {
        JSONObject response = new JSONObject();

        try {
            Orders order = ordersService.findOrderById(id);

            if (order == null) {
                response.put("status", "error");
                response.put("message", "A rendelés nem található.");
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(response.toString()).build();
            }

            ordersService.deleteOrder(id);

            response.put("status", "success");
            response.put("message", "A rendelés sikeresen törölve.");

            return Response.ok(response.toString()).build();

        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(response.toString()).build();
        }
    }
}
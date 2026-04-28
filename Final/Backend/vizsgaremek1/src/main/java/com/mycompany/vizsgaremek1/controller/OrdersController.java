package com.mycompany.vizsgaremek1.controller;

import com.mycompany.vizsgaremek1.model.Orders;
import com.mycompany.vizsgaremek1.model.Users;
import com.mycompany.vizsgaremek1.service.DeliveryService;
import com.mycompany.vizsgaremek1.service.EmailService;
import com.mycompany.vizsgaremek1.service.OrdersService;
import com.mycompany.vizsgaremek1.service.UsersService;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
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

    @EJB
    private UsersService usersService;

    @EJB
    private EmailService emailService;

    @EJB
    private DeliveryService deliveryService;

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

        // Rendelési tételek mentése az email küldéshez
        JSONArray itemsArray = request.has("items") ? request.optJSONArray("items") : null;

        if (userId == null) {
            response.put("status", "error");
            response.put("message", "A felhasználó ID megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        if (restaurantId == null) {
            response.put("status", "error");
            response.put("message", "Az étterem ID megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        if (totalPrice == null) {
            response.put("status", "error");
            response.put("message", "A végösszeg megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        if (totalPrice.compareTo(BigDecimal.ZERO) < 0) {
            response.put("status", "error");
            response.put("message", "A végösszeg nem lehet negatív.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        if (!status.equals("pending") && !status.equals("preparing")
                && !status.equals("delivering") && !status.equals("completed") && !status.equals("cancelled")) {
            response.put("status", "error");
            response.put("message", "Érvénytelen státusz.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }

        try {
            if (!ordersService.userExists(userId)) {
                response.put("status", "error");
                response.put("message", "A megadott felhasználó nem létezik.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }
            if (!ordersService.restaurantExists(restaurantId)) {
                response.put("status", "error");
                response.put("message", "A megadott étterem nem létezik.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }

            ordersService.addOrder(userId, restaurantId, deliveryAddress, status, totalPrice);
            Orders createdOrder = ordersService.getLastOrderByUserAndRestaurant(userId, restaurantId);

            // delivery rekord létrehozása
            if (createdOrder != null) {
                try {
                    deliveryService.addDelivery(
                            createdOrder.getOrderId(),
                            deliveryAddress,
                            null,
                            "pending" // Kezdeti státusz: függőben
                    );
                } catch (Exception deliveryEx) {
                    System.err.println("Delivery létrehozási hiba: " + deliveryEx.getMessage());
                }
            }

            // rendelést visszaigazoló email
            try {
                Users user = usersService.findUserById(userId);
                if (user != null && createdOrder != null && itemsArray != null) {
                    List<EmailService.OrderItemInfo> emailItems = new ArrayList<>();
                    for (int i = 0; i < itemsArray.length(); i++) {
                        JSONObject item = itemsArray.getJSONObject(i);
                        String itemName = item.optString("name", "Ismeretlen étel");
                        int quantity = item.optInt("quantity", 1);
                        BigDecimal unitPrice = item.has("price") ? item.getBigDecimal("price") : BigDecimal.ZERO;
                        BigDecimal itemTotal = unitPrice.multiply(BigDecimal.valueOf(quantity));
                        emailItems.add(new EmailService.OrderItemInfo(itemName, quantity, unitPrice, itemTotal));
                    }

                    String paymentMethod = request.optString("payment_method", "card");
                    String orderTime = LocalDateTime.now()
                            .format(DateTimeFormatter.ofPattern("yyyy.MM.dd HH:mm"));

                    emailService.sendOrderConfirmationEmail(
                            user.getEmail(),
                            user.getName(),
                            createdOrder.getOrderId(),
                            emailItems,
                            totalPrice,
                            paymentMethod,
                            deliveryAddress,
                            orderTime
                    );
                }
            } catch (Exception emailEx) {
                System.err.println("Rendelés email küldési hiba: " + emailEx.getMessage());
            }

            response.put("status", "success");
            response.put("message", "A rendelés sikeresen létrehozva.");
            if (createdOrder != null) {
                response.put("order_id", createdOrder.getOrderId());
            }
            return Response.status(Response.Status.CREATED).entity(response.toString()).build();

        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(response.toString()).build();
        }
    }

    @PUT
    @Path("/UpdateOrder/{id}")
    public Response updateOrder(@PathParam("id") Integer id, String requestBody) {
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
            Orders existingOrder = ordersService.findOrderById(id);
            if (existingOrder == null) {
                response.put("status", "error");
                response.put("message", "A rendelés nem található.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }
            String status = request.optString("status", existingOrder.getStatus().toString());
            BigDecimal totalPrice = request.has("total_price")
                    ? request.getBigDecimal("total_price") : existingOrder.getTotalPrice();
            if (!status.equals("pending") && !status.equals("preparing")
                    && !status.equals("delivering") && !status.equals("completed") && !status.equals("cancelled")) {
                response.put("status", "error");
                response.put("message", "Érvénytelen státusz.");
                return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
            }
            if (totalPrice.compareTo(BigDecimal.ZERO) < 0) {
                response.put("status", "error");
                response.put("message", "A végösszeg nem lehet negatív.");
                return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
            }
            ordersService.updateOrder(id, status, totalPrice);
            response.put("status", "success");
            response.put("message", "A rendelés sikeresen frissítve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }

    @DELETE
    @Path("/DeleteOrder/{id}")
    public Response deleteOrder(@PathParam("id") Integer id) {
        JSONObject response = new JSONObject();
        try {
            Orders order = ordersService.findOrderById(id);
            if (order == null) {
                response.put("status", "error");
                response.put("message", "A rendelés nem található.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }
            ordersService.deleteOrder(id);
            response.put("status", "success");
            response.put("message", "A rendelés sikeresen törölve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }
}

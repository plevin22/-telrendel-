package com.mycompany.vizsgaremek1.controller;

import com.mycompany.vizsgaremek1.model.OrderItems;
import com.mycompany.vizsgaremek1.service.OrderItemsService;
import java.math.BigDecimal;
import java.util.List;
import javax.ejb.EJB;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.json.JSONArray;
import org.json.JSONObject;

@Path("/orderitems")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class OrderItemsController {

    @EJB
    private OrderItemsService orderItemsService;

    @GET
    @Path("/GetAllOrderItems")
    public Response getAllOrderItems() {
        try {
            List<OrderItems> items = orderItemsService.getAllOrderItems();
            JSONArray jsonArray = new JSONArray();
            for (OrderItems oi : items) {
                JSONObject json = new JSONObject();
                json.put("order_item_id", oi.getOrderItemId());
                json.put("order_id", oi.getOrderId());
                json.put("dish_id", oi.getDishId());
                json.put("quantity", oi.getQuantity());
                json.put("price", oi.getPrice());
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
    @Path("/GetOrderItemById/{id}")
    public Response getOrderItemById(@PathParam("id") Integer id) {
        try {
            OrderItems oi = orderItemsService.findOrderItemById(id);
            if (oi == null) {
                JSONObject response = new JSONObject();
                response.put("status", "error");
                response.put("message", "A rendelési tétel nem található.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }
            JSONObject json = new JSONObject();
            json.put("order_item_id", oi.getOrderItemId());
            json.put("order_id", oi.getOrderId());
            json.put("dish_id", oi.getDishId());
            json.put("quantity", oi.getQuantity());
            json.put("price", oi.getPrice());
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
    @Path("/GetOrderItemsByOrder/{orderId}")
    public Response getOrderItemsByOrder(@PathParam("orderId") Integer orderId) {
        try {
            List<OrderItems> items = orderItemsService.getOrderItemsByOrderId(orderId);
            JSONArray jsonArray = new JSONArray();
            for (OrderItems oi : items) {
                JSONObject json = new JSONObject();
                json.put("order_item_id", oi.getOrderItemId());
                json.put("order_id", oi.getOrderId());
                json.put("dish_id", oi.getDishId());
                json.put("quantity", oi.getQuantity());
                json.put("price", oi.getPrice());
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
    @Path("/AddOrderItem")
    public Response addOrderItem(String requestBody) {
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

        Integer orderId = request.optInt("order_id", 0);
        Integer dishId = request.optInt("dish_id", 0);
        Integer quantity = request.optInt("quantity", 1);

        // Validációk
        if (orderId == 0) {
            response.put("status", "error");
            response.put("message", "Az order_id megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        if (dishId == 0) {
            response.put("status", "error");
            response.put("message", "A dish_id megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        if (quantity <= 0) {
            response.put("status", "error");
            response.put("message", "A mennyiségnek pozitív számnak kell lennie.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }

        try {
            // Rendelés létezésének ellenőrzése
            if (!orderItemsService.orderExists(orderId)) {
                response.put("status", "error");
                response.put("message", "A megadott rendelés nem létezik.");
                return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
            }
            
            // Étel létezésének ellenőrzése
            if (!orderItemsService.dishExists(dishId)) {
                response.put("status", "error");
                response.put("message", "A megadott étel nem létezik.");
                return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
            }

            // Étel elérhetőségének ellenőrzése
            if (!orderItemsService.isDishAvailable(dishId)) {
                response.put("status", "error");
                response.put("message", "A megadott étel jelenleg nem elérhető.");
                return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
            }

            // ár számítása adatbázisból
            BigDecimal unitPrice = orderItemsService.getDishPrice(dishId);
            if (unitPrice == null) {
                response.put("status", "error");
                response.put("message", "Nem sikerült lekérdezni az étel árát.");
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
            }
            
            // Teljes ár = egységár × mennyiség
            BigDecimal calculatedPrice = unitPrice.multiply(BigDecimal.valueOf(quantity));

            // Tétel hozzáadása a helyes árral
            orderItemsService.addOrderItem(orderId, dishId, quantity, calculatedPrice);
            
            response.put("status", "success");
            response.put("message", "A rendelési tétel sikeresen létrehozva.");
            response.put("unit_price", unitPrice);
            response.put("quantity", quantity);
            response.put("total_price", calculatedPrice);
            return Response.status(Response.Status.CREATED).entity(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }

    @PUT
    @Path("/UpdateOrderItem/{id}")
    public Response updateOrderItem(@PathParam("id") Integer id, String requestBody) {
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
            OrderItems existing = orderItemsService.findOrderItemById(id);
            if (existing == null) {
                response.put("status", "error");
                response.put("message", "A rendelési tétel nem található.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }

            Integer quantity = request.has("quantity") ? request.getInt("quantity") : existing.getQuantity();

            if (quantity <= 0) {
                response.put("status", "error");
                response.put("message", "A mennyiségnek pozitív számnak kell lennie.");
                return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
            }

            // ár újraszámítása az adatbázisról
            BigDecimal unitPrice = orderItemsService.getDishPrice(existing.getDishId());
            if (unitPrice == null) {
                response.put("status", "error");
                response.put("message", "Nem sikerült lekérdezni az étel árát.");
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
            }
            
            BigDecimal calculatedPrice = unitPrice.multiply(BigDecimal.valueOf(quantity));

            orderItemsService.updateOrderItem(id, quantity, calculatedPrice);
            
            response.put("status", "success");
            response.put("message", "A rendelési tétel sikeresen frissítve.");
            response.put("unit_price", unitPrice);
            response.put("quantity", quantity);
            response.put("total_price", calculatedPrice);
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }

    @DELETE
    @Path("/DeleteOrderItem/{id}")
    public Response deleteOrderItem(@PathParam("id") Integer id) {
        JSONObject response = new JSONObject();
        try {
            OrderItems oi = orderItemsService.findOrderItemById(id);
            if (oi == null) {
                response.put("status", "error");
                response.put("message", "A rendelési tétel nem található.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }
            orderItemsService.deleteOrderItem(id);
            response.put("status", "success");
            response.put("message", "A rendelési tétel sikeresen törölve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }
}
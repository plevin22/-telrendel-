package com.mycompany.vizsgaremek1.controller;

import com.mycompany.vizsgaremek1.model.Delivery;
import com.mycompany.vizsgaremek1.service.DeliveryService;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.ejb.EJB;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.json.JSONArray;
import org.json.JSONObject;

@Path("/delivery")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class DeliveryController {

    @EJB
    private DeliveryService deliveryService;

    @GET
    @Path("/GetDeliveryByOrder/{orderId}")
    public Response getDeliveryByOrder(@PathParam("orderId") Integer orderId) {
        try {
            List<Delivery> deliveries = deliveryService.getDeliveryByOrder(orderId);
            JSONArray jsonArray = new JSONArray();
            for (Delivery d : deliveries) {
                jsonArray.put(deliveryToJson(d));
            }
            return Response.ok(jsonArray.toString()).build();
        } catch (Exception e) {
            return errorResponse("Hiba történt a lekérdezés során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @GET
    @Path("/GetPendingDeliveries")
    public Response getPendingDeliveries() {
        try {
            List<Delivery> deliveries = deliveryService.getPendingDeliveries();
            JSONArray jsonArray = new JSONArray();
            for (Delivery d : deliveries) {
                jsonArray.put(deliveryToJson(d));
            }
            return Response.ok(jsonArray.toString()).build();
        } catch (Exception e) {
            return errorResponse("Hiba történt a lekérdezés során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @POST
    @Path("/AddDelivery")
    public Response addDelivery(String requestBody) {
        if (requestBody == null || requestBody.trim().isEmpty()) {
            return errorResponse("A kérés törzse üres.", Response.Status.BAD_REQUEST);
        }
        JSONObject request;
        try {
            request = new JSONObject(requestBody);
        } catch (Exception e) {
            return errorResponse("Érvénytelen JSON formátum.", Response.Status.BAD_REQUEST);
        }

        Integer orderId = request.optInt("order_id", 0);
        String deliveryAddress = request.optString("delivery_address", null);
        String deliveryTimeStr = request.optString("delivery_time", null);
        String status = request.optString("status", "pending");

        if (orderId == 0) {
            return errorResponse("Az order_id megadása kötelező.", Response.Status.BAD_REQUEST);
        }
        if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
            return errorResponse("A szállítási cím megadása kötelező.", Response.Status.BAD_REQUEST);
        }
        if (!isValidStatus(status)) {
            return errorResponse("Érvénytelen státusz. Engedélyezett: pending, dispatched, delivering, completed, failed.", Response.Status.BAD_REQUEST);
        }

        try {
            if (!deliveryService.orderExists(orderId)) {
                return errorResponse("A megadott rendelés nem létezik.", Response.Status.BAD_REQUEST);
            }

            Date deliveryTime = null;
            if (deliveryTimeStr != null && !deliveryTimeStr.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                deliveryTime = sdf.parse(deliveryTimeStr);
            }

            deliveryService.addDelivery(orderId, deliveryAddress, deliveryTime, status);

            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("message", "A kiszállítás sikeresen létrehozva.");
            return Response.status(Response.Status.CREATED).entity(response.toString()).build();
        } catch (Exception e) {
            return errorResponse("Adatbázis hiba történt.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @PUT
    @Path("/UpdateDeliveryStatus/{id}")
    public Response updateDeliveryStatus(@PathParam("id") Integer id, String requestBody) {
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
            Delivery existing = deliveryService.findDeliveryById(id);
            if (existing == null) {
                return errorResponse("A kiszállítás nem található.", Response.Status.NOT_FOUND);
            }

            String status = request.optString("status", existing.getStatus().toString());
            if (!isValidStatus(status)) {
                return errorResponse("Érvénytelen státusz.", Response.Status.BAD_REQUEST);
            }

            deliveryService.updateDeliveryStatus(id, status);

            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("message", "A kiszállítás státusza sikeresen frissítve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            return errorResponse("Adatbázis hiba történt.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    @DELETE
    @Path("/DeleteDelivery/{id}")
    public Response deleteDelivery(@PathParam("id") Integer id) {
        try {
            Delivery d = deliveryService.findDeliveryById(id);
            if (d == null) {
                return errorResponse("A kiszállítás nem található.", Response.Status.NOT_FOUND);
            }
            deliveryService.deleteDelivery(id);

            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("message", "A kiszállítás sikeresen törölve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            return errorResponse("Adatbázis hiba történt.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    private boolean isValidStatus(String status) {
        return status != null && (status.equals("pending") || status.equals("dispatched") || 
               status.equals("delivering") || status.equals("completed") || status.equals("failed"));
    }

    private JSONObject deliveryToJson(Delivery d) {
        JSONObject json = new JSONObject();
        json.put("delivery_id", d.getDeliveryId());
        json.put("order_id", d.getOrderId());
        json.put("delivery_address", d.getDeliveryAddress());
        json.put("delivery_time", d.getDeliveryTime() != null ? d.getDeliveryTime().toString() : null);
        json.put("status", d.getStatus() != null ? d.getStatus().toString() : null);
        return json;
    }

    private Response errorResponse(String message, Response.Status status) {
        JSONObject response = new JSONObject();
        response.put("status", "error");
        response.put("message", message);
        return Response.status(status).entity(response.toString()).build();
    }
}

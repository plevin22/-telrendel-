package com.mycompany.vizsgaremek1.controller;

import com.mycompany.vizsgaremek1.model.Payments;
import com.mycompany.vizsgaremek1.service.PaymentsService;
import java.math.BigDecimal;
import java.util.List;
import javax.ejb.EJB;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.json.JSONArray;
import org.json.JSONObject;

@Path("/payments")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PaymentsController {

    @EJB
    private PaymentsService paymentsService;

    @GET
    @Path("/GetAllPayments")
    public Response getAllPayments() {
        try {
            List<Payments> payments = paymentsService.getAllPayments();
            JSONArray jsonArray = new JSONArray();
            for (Payments p : payments) {
                JSONObject json = new JSONObject();
                json.put("payment_id", p.getPaymentId());
                json.put("order_id", p.getOrderId());
                json.put("amount", p.getAmount());
                json.put("method", p.getMethod() != null ? p.getMethod().toString() : null);
                json.put("status", p.getStatus().toString());
                json.put("created_at", p.getCreatedAt() != null ? p.getCreatedAt().toString() : null);
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
    @Path("/GetPaymentById/{id}")
    public Response getPaymentById(@PathParam("id") Integer id) {
        try {
            Payments p = paymentsService.findPaymentById(id);
            if (p == null) {
                JSONObject response = new JSONObject();
                response.put("status", "error");
                response.put("message", "A fizetés nem található.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }
            JSONObject json = new JSONObject();
            json.put("payment_id", p.getPaymentId());
            json.put("order_id", p.getOrderId());
            json.put("amount", p.getAmount());
            json.put("method", p.getMethod() != null ? p.getMethod().toString() : null);
            json.put("status", p.getStatus().toString());
            json.put("created_at", p.getCreatedAt() != null ? p.getCreatedAt().toString() : null);
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
    @Path("/GetPaymentByOrder/{orderId}")
    public Response getPaymentByOrder(@PathParam("orderId") Integer orderId) {
        try {
            Payments p = paymentsService.getPaymentByOrderId(orderId);
            if (p == null) {
                JSONObject response = new JSONObject();
                response.put("status", "error");
                response.put("message", "A rendeléshez nem tartozik fizetés.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }
            JSONObject json = new JSONObject();
            json.put("payment_id", p.getPaymentId());
            json.put("order_id", p.getOrderId());
            json.put("amount", p.getAmount());
            json.put("method", p.getMethod() != null ? p.getMethod().toString() : null);
            json.put("status", p.getStatus().toString());
            json.put("created_at", p.getCreatedAt() != null ? p.getCreatedAt().toString() : null);
            return Response.ok(json.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject response = new JSONObject();
            response.put("status", "error");
            response.put("message", "Hiba történt a lekérdezés során.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }

    @POST
    @Path("/AddPayment")
    public Response addPayment(String requestBody) {
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
        BigDecimal amount = request.has("amount") ? request.getBigDecimal("amount") : null;
        String method = request.optString("method", null);
        String status = request.optString("status", "pending");

        if (orderId == 0) {
            response.put("status", "error");
            response.put("message", "Az order_id megadása kötelező.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            response.put("status", "error");
            response.put("message", "Az összegnek pozitív számnak kell lennie.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        if (method == null || (!method.equals("card") && !method.equals("cash") && !method.equals("paypal"))) {
            response.put("status", "error");
            response.put("message", "Érvénytelen fizetési mód. Engedélyezett: card, cash, paypal.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }
        if (!status.equals("pending") && !status.equals("paid") && !status.equals("failed")) {
            response.put("status", "error");
            response.put("message", "Érvénytelen státusz. Engedélyezett: pending, paid, failed.");
            return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
        }

        try {
            if (!paymentsService.orderExists(orderId)) {
                response.put("status", "error");
                response.put("message", "A megadott rendelés nem létezik.");
                return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
            }
            paymentsService.addPayment(orderId, amount, method, status);
            response.put("status", "success");
            response.put("message", "A fizetés sikeresen létrehozva.");
            return Response.status(Response.Status.CREATED).entity(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }

    @PUT
    @Path("/UpdatePayment/{id}")
    public Response updatePayment(@PathParam("id") Integer id, String requestBody) {
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
            Payments existing = paymentsService.findPaymentById(id);
            if (existing == null) {
                response.put("status", "error");
                response.put("message", "A fizetés nem található.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }

            String status = request.optString("status", existing.getStatus().toString());

            if (!status.equals("pending") && !status.equals("paid") && !status.equals("failed")) {
                response.put("status", "error");
                response.put("message", "Érvénytelen státusz.");
                return Response.status(Response.Status.BAD_REQUEST).entity(response.toString()).build();
            }

            paymentsService.updatePayment(id, status);
            response.put("status", "success");
            response.put("message", "A fizetés sikeresen frissítve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }

    @DELETE
    @Path("/DeletePayment/{id}")
    public Response deletePayment(@PathParam("id") Integer id) {
        JSONObject response = new JSONObject();
        try {
            Payments p = paymentsService.findPaymentById(id);
            if (p == null) {
                response.put("status", "error");
                response.put("message", "A fizetés nem található.");
                return Response.status(Response.Status.NOT_FOUND).entity(response.toString()).build();
            }
            paymentsService.deletePayment(id);
            response.put("status", "success");
            response.put("message", "A fizetés sikeresen törölve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Adatbázis hiba történt.");
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(response.toString()).build();
        }
    }
}

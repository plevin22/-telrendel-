package com.mycompany.vizsgaremek1.controller;

import com.mycompany.vizsgaremek1.model.Reviews;
import com.mycompany.vizsgaremek1.service.ReviewsService;
import java.util.List;
import javax.ejb.EJB;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.json.JSONArray;
import org.json.JSONObject;

@Path("/reviews")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ReviewsController {

    @EJB
    private ReviewsService reviewsService;

    // Csillag értékelés szöveges címkéje
    private String getRatingLabel(int rating) {
        switch (rating) {
            case 1:
                return "Borzalmas";
            case 2:
                return "Rossz";
            case 3:
                return "Elmegy";
            case 4:
                return "Jó";
            case 5:
                return "Tökéletes";
            default:
                return "Ismeretlen";
        }
    }

    // Csillagok megjelenítése (★☆)
    private String getStarsDisplay(int rating) {
        StringBuilder stars = new StringBuilder();
        for (int i = 0; i < 5; i++) {
            stars.append(i < rating ? "★" : "☆");
        }
        return stars.toString();
    }

    // Review JSON objektummá alakítása
    private JSONObject reviewToJson(Reviews review) {
        JSONObject json = new JSONObject();
        json.put("review_id", review.getReviewId());
        json.put("user_id", review.getUserId());
        json.put("restaurant_id", review.getRestaurantId());
        json.put("order_id", review.getOrderId() != null ? review.getOrderId() : JSONObject.NULL);
        json.put("rating", review.getRating());
        json.put("rating_label", getRatingLabel(review.getRating()));
        json.put("stars", getStarsDisplay(review.getRating()));
        json.put("comment", review.getComment() != null ? review.getComment() : "");
        json.put("created_at", review.getCreatedAt() != null ? review.getCreatedAt().toString() : null);

        String userName = reviewsService.getUserNameById(review.getUserId());
        String restaurantName = reviewsService.getRestaurantNameById(review.getRestaurantId());
        json.put("user_name", userName != null ? userName : "Ismeretlen felhasználó");
        json.put("restaurant_name", restaurantName != null ? restaurantName : "Ismeretlen étterem");

        return json;
    }

    private Response errorResponse(String message, Response.Status status) {
        JSONObject response = new JSONObject();
        response.put("status", "error");
        response.put("message", message);
        return Response.status(status).entity(response.toString()).build();
    }

    /**
     * Értékelés lekérdezése ID alapján. GET /api/reviews/GetReviewById/{id}
     */
    @GET
    @Path("/GetReviewById/{id}")
    public Response getReviewById(@PathParam("id") Integer id) {
        try {
            Reviews review = reviewsService.findReviewById(id);
            if (review == null) {
                return errorResponse("Az értékelés nem található.", Response.Status.NOT_FOUND);
            }
            return Response.ok(reviewToJson(review).toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Hiba történt a lekérdezés során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Étterem összes értékelése. GET
     * /api/reviews/GetReviewsByRestaurant/{restaurantId}
     */
    @GET
    @Path("/GetReviewsByRestaurant/{restaurantId}")
    public Response getReviewsByRestaurant(@PathParam("restaurantId") Integer restaurantId) {
        try {
            List<Reviews> reviews = reviewsService.getReviewsByRestaurant(restaurantId);
            JSONArray jsonArray = new JSONArray();
            for (Reviews review : reviews) {
                jsonArray.put(reviewToJson(review));
            }
            return Response.ok(jsonArray.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Hiba történt a lekérdezés során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Felhasználó összes értékelése. GET /api/reviews/GetReviewsByUser/{userId}
     */
    @GET
    @Path("/GetReviewsByUser/{userId}")
    public Response getReviewsByUser(@PathParam("userId") Integer userId) {
        try {
            List<Reviews> reviews = reviewsService.getReviewsByUser(userId);
            JSONArray jsonArray = new JSONArray();
            for (Reviews review : reviews) {
                jsonArray.put(reviewToJson(review));
            }
            return Response.ok(jsonArray.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Hiba történt a lekérdezés során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Étterem átlagos értékelése. GET
     * /api/reviews/GetAverageRating/{restaurantId}
     */
    @GET
    @Path("/GetAverageRating/{restaurantId}")
    public Response getAverageRating(@PathParam("restaurantId") Integer restaurantId) {
        try {
            Object[] result = reviewsService.getAverageRatingByRestaurant(restaurantId);
            JSONObject json = new JSONObject();

            if (result != null && result[0] != null) {
                double avgRating = ((Number) result[0]).doubleValue();
                int totalReviews = ((Number) result[1]).intValue();
                int roundedRating = (int) Math.round(avgRating);

                json.put("restaurant_id", restaurantId);
                json.put("average_rating", Math.round(avgRating * 10.0) / 10.0);
                json.put("rating_label", getRatingLabel(roundedRating));
                json.put("stars", getStarsDisplay(roundedRating));
                json.put("total_reviews", totalReviews);
            } else {
                json.put("restaurant_id", restaurantId);
                json.put("average_rating", 0);
                json.put("rating_label", "Nincs értékelés");
                json.put("stars", "☆☆☆☆☆");
                json.put("total_reviews", 0);
            }

            return Response.ok(json.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Hiba történt a lekérdezés során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Legutóbbi értékelések (részletekkel). GET
     * /api/reviews/GetRecentReviews/{limit}
     */
    @GET
    @Path("/GetRecentReviews/{limit}")
    public Response getRecentReviews(@PathParam("limit") Integer limit) {
        try {
            List<Object[]> results = reviewsService.getRecentReviews(limit);
            JSONArray jsonArray = new JSONArray();

            for (Object[] row : results) {
                JSONObject json = new JSONObject();
                json.put("review_id", row[0]);
                int rating = ((Number) row[1]).intValue();
                json.put("rating", rating);
                json.put("rating_label", getRatingLabel(rating));
                json.put("stars", getStarsDisplay(rating));
                json.put("comment", row[2] != null ? row[2].toString() : "");
                json.put("created_at", row[3] != null ? row[3].toString() : null);
                json.put("user_name", row[4] != null ? row[4].toString() : "Ismeretlen");
                json.put("restaurant_name", row[6] != null ? row[6].toString() : "Ismeretlen");
                jsonArray.put(json);
            }

            return Response.ok(jsonArray.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Hiba történt a lekérdezés során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Új értékelés hozzáadása. POST /api/reviews/AddReview
     *
     * Egy rendelést csak egyszer lehet értékelni. A rendelésnek completed
     * státuszúnak kell lennie. Az étterem automatikusan a rendelésből jön.
     *
     * JSON body: { "user_id": 18, "order_id": 1, "rating": 4, "comment":
     * "Nagyon finom volt!" }
     */
    @POST
    @Path("/AddReview")
    public Response addReview(String requestBody) {
        if (requestBody == null || requestBody.trim().isEmpty()) {
            return errorResponse("A kérés törzse üres.", Response.Status.BAD_REQUEST);
        }

        JSONObject request;
        try {
            request = new JSONObject(requestBody);
        } catch (Exception e) {
            return errorResponse("Érvénytelen JSON formátum.", Response.Status.BAD_REQUEST);
        }

        // Kötelező mezők
        if (!request.has("user_id")) {
            return errorResponse("A felhasználó azonosító (user_id) megadása kötelező.", Response.Status.BAD_REQUEST);
        }
        if (!request.has("order_id")) {
            return errorResponse("A rendelés azonosító (order_id) megadása kötelező.", Response.Status.BAD_REQUEST);
        }
        if (!request.has("rating")) {
            return errorResponse("Az értékelés (rating) megadása kötelező.", Response.Status.BAD_REQUEST);
        }

        Integer userId = request.getInt("user_id");
        Integer orderId = request.getInt("order_id");
        Integer rating = request.getInt("rating");
        String comment = request.optString("comment", null);

        // Rating validálás (1-5 csillag)
        if (rating < 1 || rating > 5) {
            return errorResponse("Az értékelés 1 és 5 között kell legyen. (1-Borzalmas, 2-Rossz, 3-Elmegy, 4-Jó, 5-Tökéletes)", Response.Status.BAD_REQUEST);
        }

        // Komment hossz validálás (max 150 karakter)
        if (comment != null && comment.length() > 150) {
            return errorResponse("Az üzenet maximum 150 karakter lehet.", Response.Status.BAD_REQUEST);
        }

        try {
            // Ellenőrzés: a rendelés létezik-e, completed-e, és az adott felhasználóé-e
            if (!reviewsService.isValidCompletedOrder(orderId, userId)) {
                return errorResponse("A rendelés nem található, nem a tiéd, vagy még nincs teljesítve.", Response.Status.FORBIDDEN);
            }

            // Ellenőrzés: a rendelést már értékelték-e
            if (reviewsService.isOrderAlreadyReviewed(orderId)) {
                return errorResponse("Ezt a rendelést már értékelted.", Response.Status.CONFLICT);
            }

            // Étterem ID automatikusan a rendelésből
            Integer restaurantId = reviewsService.getRestaurantIdByOrder(orderId);
            if (restaurantId == null) {
                return errorResponse("A rendeléshez tartozó étterem nem található.", Response.Status.NOT_FOUND);
            }

            reviewsService.addReview(userId, restaurantId, orderId, rating, comment);

            String userName = reviewsService.getUserNameById(userId);
            String restaurantName = reviewsService.getRestaurantNameById(restaurantId);

            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("message", "Értékelés sikeresen hozzáadva.");
            response.put("order_id", orderId);
            response.put("rating", rating);
            response.put("rating_label", getRatingLabel(rating));
            response.put("stars", getStarsDisplay(rating));
            response.put("user_name", userName != null ? userName : "Ismeretlen");
            response.put("restaurant_name", restaurantName != null ? restaurantName : "Ismeretlen");
            if (comment != null && !comment.isEmpty()) {
                response.put("comment", comment);
            }

            return Response.status(Response.Status.CREATED).entity(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Adatbázis hiba történt.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Értékelés módosítása. PUT /api/reviews/UpdateReview/{id}
     */
    @PUT
    @Path("/UpdateReview/{id}")
    public Response updateReview(@PathParam("id") Integer id, String requestBody) {
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
            Reviews existing = reviewsService.findReviewById(id);
            if (existing == null) {
                return errorResponse("Az értékelés nem található.", Response.Status.NOT_FOUND);
            }

            Integer rating = request.has("rating") ? request.getInt("rating") : existing.getRating();
            String comment = request.has("comment") ? request.optString("comment", null) : existing.getComment();

            if (rating < 1 || rating > 5) {
                return errorResponse("Az értékelés 1 és 5 között kell legyen. (1-Borzalmas, 2-Rossz, 3-Elmegy, 4-Jó, 5-Tökéletes)", Response.Status.BAD_REQUEST);
            }

            if (comment != null && comment.length() > 150) {
                return errorResponse("Az üzenet maximum 150 karakter lehet.", Response.Status.BAD_REQUEST);
            }

            reviewsService.updateReview(id, rating, comment);

            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("message", "Értékelés sikeresen módosítva.");
            response.put("rating", rating);
            response.put("rating_label", getRatingLabel(rating));
            response.put("stars", getStarsDisplay(rating));
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Adatbázis hiba történt.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Értékelés törlése. DELETE /api/reviews/DeleteReview/{id}
     */
    @DELETE
    @Path("/DeleteReview/{id}")
    public Response deleteReview(@PathParam("id") Integer id) {
        try {
            Reviews review = reviewsService.findReviewById(id);
            if (review == null) {
                return errorResponse("Az értékelés nem található.", Response.Status.NOT_FOUND);
            }

            reviewsService.deleteReview(id);

            JSONObject response = new JSONObject();
            response.put("status", "success");
            response.put("message", "Értékelés sikeresen törölve.");
            return Response.ok(response.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Adatbázis hiba történt.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Értékelés keresése comment alapján. GET
     * /api/reviews/SearchByComment/{keyword}
     */
    @GET
    @Path("/SearchByComment/{keyword}")
    public Response searchByComment(@PathParam("keyword") String keyword) {
        try {
            List<Reviews> reviews = reviewsService.searchReviewsByComment(keyword);
            JSONArray jsonArray = new JSONArray();
            for (Reviews review : reviews) {
                jsonArray.put(reviewToJson(review));
            }
            return Response.ok(jsonArray.toString()).build();
        } catch (Exception e) {
            e.printStackTrace();
            return errorResponse("Hiba történt a keresés során.", Response.Status.INTERNAL_SERVER_ERROR);
        }
    }
}

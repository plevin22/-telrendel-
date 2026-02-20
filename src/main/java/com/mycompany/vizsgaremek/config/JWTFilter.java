package com.mycompany.vizsgaremek.config;

import java.io.IOException;
import javax.annotation.Priority;
import javax.ws.rs.Priorities;
import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.container.ContainerRequestFilter;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.Provider;

@Provider
@JWTNeeded
@Priority(Priorities.AUTHENTICATION)
public class JWTFilter implements ContainerRequestFilter {

    @Override
    public void filter(ContainerRequestContext requestCtx) throws IOException {

        String authHeader = requestCtx.getHeaderString("Authorization");

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            requestCtx.abortWith(
                Response.status(Response.Status.UNAUTHORIZED)
                .entity("{\"error\":\"Missing or invalid Authorization header\"}")
                .build()
            );
            return;
        }

        String token = authHeader.substring("Bearer".length()).trim();

        Boolean valid = JWT.validateJwt(token);

        if (valid == null) {
            requestCtx.abortWith(Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\":\"Token expired\"}")
                    .build());
        }

        if (valid == false) {
            requestCtx.abortWith(Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\":\"Invalid token\"}")
                    .build());
        }
    }
}

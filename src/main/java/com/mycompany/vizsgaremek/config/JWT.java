package com.mycompany.vizsgaremek.config;

import com.mycompany.vizsgaremek.model.Users;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.SignatureException;
import io.jsonwebtoken.UnsupportedJwtException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Base64;
import java.util.Date;

public class JWT {

    private static final String JWT_SECRET =
        "a3f4c2d9e8b71a5f6c3d2b9f0e1a4c7d8f9b0c1a2d3e4f56789ab0c1d2e3f41b";

    // TOKEN GENERÁLÁS
    public static String createJwt(Users u) {

        Instant now = Instant.now();

        return Jwts.builder()
                .setIssuer("Vizsgaremek")
                .setSubject("vizsgaremek_backend")
                .claim("id", u.getId())
                .claim("email", u.getEmail())
                .claim("role", u.getRole())
                .setIssuedAt(Date.from(now))
                .setExpiration(Date.from(now.plus(30, ChronoUnit.MINUTES))) // 30 perc
                .signWith(
                        SignatureAlgorithm.HS256,
                        Base64.getDecoder().decode(JWT_SECRET)  // <-- Javított rész
                )
                .compact();
    }

    // TOKEN VALIDÁLÁS
    // true = érvényes
    // false = hibás
    // null = lejárt
    public static Boolean validateJwt(String token) {

        try {
            Jws<Claims> tokenResult = Jwts.parser()
                    .setSigningKey(Base64.getDecoder().decode(JWT_SECRET))  // <-- Javított rész
                    .parseClaimsJws(token);

            Integer id = tokenResult.getBody().get("id", Integer.class);

            return id != null;

        } catch (SignatureException | MalformedJwtException |
                 IllegalArgumentException | UnsupportedJwtException ex) {
            return false;

        } catch (ExpiredJwtException ex) {
            return null;
        }
    }
}

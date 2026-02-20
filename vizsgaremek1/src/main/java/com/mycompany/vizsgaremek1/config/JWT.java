package com.mycompany.vizsgaremek1.config;

import com.mycompany.vizsgaremek1.model.Users;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import java.security.Key;
import java.util.Date;

public class JWT {

    // Titkos kulcs a token aláírásához
    private static final Key SECRET_KEY = Keys.secretKeyFor(SignatureAlgorithm.HS256);
    
    // Token érvényességi ideje (24 óra milliszekundumban)
    private static final long EXPIRATION_TIME = 24 * 60 * 60 * 1000;

    /**
     * JWT token létrehozása a felhasználó adatai alapján.
     * @param user a bejelentkezett felhasználó
     * @return generált JWT token
     */
    public static String createToken(Users user) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + EXPIRATION_TIME);

        return Jwts.builder()
                .setSubject(user.getUserId().toString())
                .claim("email", user.getEmail())
                .claim("name", user.getName())
                .claim("role", user.getRole().toString())
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(SECRET_KEY)
                .compact();
    }

    /**
     * JWT token validálása és felhasználó ID kinyerése.
     * @param token a validálandó token
     * @return felhasználó ID vagy null ha érvénytelen
     */
    public static Integer validateTokenAndGetUserId(String token) {
        try {
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(SECRET_KEY)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();

            return Integer.parseInt(claims.getSubject());
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Token érvényességének ellenőrzése.
     * @param token a vizsgálandó token
     * @return true ha érvényes, false egyébként
     */
    public static boolean isTokenValid(String token) {
        try {
            Jwts.parserBuilder()
                    .setSigningKey(SECRET_KEY)
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Claims kinyerése a tokenből.
     * @param token a JWT token
     * @return Claims objektum vagy null ha érvénytelen
     */
    public static Claims getClaims(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(SECRET_KEY)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Szerepkör kinyerése a tokenből.
     * @param token a JWT token
     * @return szerepkör string vagy null
     */
    public static String getRoleFromToken(String token) {
        Claims claims = getClaims(token);
        if (claims != null) {
            return claims.get("role", String.class);
        }
        return null;
    }
}
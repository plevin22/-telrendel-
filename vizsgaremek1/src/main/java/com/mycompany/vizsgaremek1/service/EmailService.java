package com.mycompany.vizsgaremek1.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Properties;
import javax.ejb.Asynchronous;
import javax.ejb.Stateless;
import javax.mail.*;
import javax.mail.internet.*;

// KLSZ Faloda - Email küldő szolgáltatás
// Gmail SMTP-vel működik.
@Stateless
public class EmailService {

    //smtp konfig
    private static final String EMAIL_FROM = "noreply.klszfaloda@gmail.com";        // Gmail cím
    private static final String EMAIL_PASSWORD = "dtsn lvxn zwij hqbn";     // Gmail alkalmazásjelszó)
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";

    @Asynchronous
    public void sendEmail(String to, String subject, String htmlBody) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.trust", SMTP_HOST);

            Session session = Session.getInstance(props);

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM, "KLSZ Faloda"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(htmlBody, "text/html; charset=UTF-8");

            Transport transport = session.getTransport("smtp");
            transport.connect(SMTP_HOST, Integer.parseInt(SMTP_PORT), EMAIL_FROM, EMAIL_PASSWORD);
            transport.sendMessage(message, message.getAllRecipients());
            transport.close();

            System.out.println("Email sikeresen elküldve: " + to + " | Tárgy: " + subject);

        } catch (Exception e) {
            System.err.println("Email küldési hiba (" + to + "): " + e.getMessage());
            e.printStackTrace();
        }
    }

    //regisztrációs email
    public void sendRegistrationEmail(String toEmail, String userName) {
        String subject = "Üdvözlünk a KLSZ Falodánál!";
        String html = buildEmailTemplate(
                "Üdvözlünk, " + userName + "!",
                "<p>Regisztrációja sikeres volt.</p>"
                + "<p>Üdvözlünk a KLSZ Falodánál! Most már böngészheted éttermeinket, "
                + "rendelhetsz kedvenc ételeidből, és élvezheted a gyors kiszállítást Pécsre.</p>"
                + "<p style='text-align:center; margin-top:20px;'>"
                + "<a href='http://localhost:8080' style='background-color:#f0c040; color:#1a1a2e; "
                + "padding:12px 30px; text-decoration:none; border-radius:8px; font-weight:bold;'>"
                + "Kezdj el rendelni!</a></p>"
        );
        sendEmail(toEmail, subject, html);
    }

    //rendelés visszaigazoló email
    public static class OrderItemInfo {

        public String name;
        public int quantity;
        public BigDecimal unitPrice;
        public BigDecimal totalPrice;

        public OrderItemInfo(String name, int quantity, BigDecimal unitPrice, BigDecimal totalPrice) {
            this.name = name;
            this.quantity = quantity;
            this.unitPrice = unitPrice;
            this.totalPrice = totalPrice;
        }
    }

    public void sendOrderConfirmationEmail(String toEmail, String userName, int orderId,
            List<OrderItemInfo> items, BigDecimal totalPrice,
            String paymentMethod, String deliveryAddress,
            String orderTime) {
        String subject = "Rendelés visszaigazolás - #" + orderId;

        // Tételek táblázata
        StringBuilder itemsHtml = new StringBuilder();
        itemsHtml.append("<table style='width:100%; border-collapse:collapse; margin:15px 0;'>");
        itemsHtml.append("<tr style='background-color:#f0c040; color:#1a1a2e;'>");
        itemsHtml.append("<th style='padding:10px; text-align:left; border:1px solid #333;'>Étel</th>");
        itemsHtml.append("<th style='padding:10px; text-align:center; border:1px solid #333;'>Mennyiség</th>");
        itemsHtml.append("<th style='padding:10px; text-align:right; border:1px solid #333;'>Egységár</th>");
        itemsHtml.append("<th style='padding:10px; text-align:right; border:1px solid #333;'>Összesen</th>");
        itemsHtml.append("</tr>");

        for (OrderItemInfo item : items) {
            itemsHtml.append("<tr style='background-color:#2a2a3e;'>");
            itemsHtml.append("<td style='padding:8px; border:1px solid #333; color:#e0e0e0;'>").append(item.name).append("</td>");
            itemsHtml.append("<td style='padding:8px; border:1px solid #333; color:#e0e0e0; text-align:center;'>").append(item.quantity).append(" db</td>");
            itemsHtml.append("<td style='padding:8px; border:1px solid #333; color:#e0e0e0; text-align:right;'>").append(formatPrice(item.unitPrice)).append("</td>");
            itemsHtml.append("<td style='padding:8px; border:1px solid #333; color:#f0c040; text-align:right; font-weight:bold;'>").append(formatPrice(item.totalPrice)).append("</td>");
            itemsHtml.append("</tr>");
        }

        // Összesen sor
        itemsHtml.append("<tr style='background-color:#1a1a2e;'>");
        itemsHtml.append("<td colspan='3' style='padding:10px; border:1px solid #333; color:#e0e0e0; text-align:right; font-weight:bold;'>Végösszeg:</td>");
        itemsHtml.append("<td style='padding:10px; border:1px solid #333; color:#f0c040; text-align:right; font-weight:bold; font-size:16px;'>").append(formatPrice(totalPrice)).append("</td>");
        itemsHtml.append("</tr>");
        itemsHtml.append("</table>");

        // Fizetési mód magyar fordítása
        String paymentMethodHu = translatePaymentMethod(paymentMethod);

        String html = buildEmailTemplate(
                "Rendelés visszaigazolás - #" + orderId,
                "<p>Kedves " + userName + "!</p>"
                + "<p>Köszönjük a rendelésed! Az alábbiakban megtalálod a rendelésed részleteit:</p>"
                + "<div style='background-color:#16213e; padding:15px; border-radius:8px; margin:15px 0;'>"
                + "<p style='color:#f0c040; margin:5px 0;'><strong>Rendelésszám:</strong> #" + orderId + "</p>"
                + "<p style='color:#e0e0e0; margin:5px 0;'><strong>Időpont:</strong> " + orderTime + "</p>"
                + "<p style='color:#e0e0e0; margin:5px 0;'><strong>Szállítási cím:</strong> " + deliveryAddress + "</p>"
                + "<p style='color:#e0e0e0; margin:5px 0;'><strong>Fizetési mód:</strong> " + paymentMethodHu + "</p>"
                + "</div>"
                + "<h3 style='color:#f0c040;'>Rendelt tételek:</h3>"
                + itemsHtml.toString()
                + "<p style='color:#888; font-size:12px; margin-top:20px;'>A rendelésed feldolgozás alatt van. Hamarosan megkapod!</p>"
        );
        sendEmail(toEmail, subject, html);
    }

    //profil módosítás email
    public void sendProfileUpdateEmail(String toEmail, String userName,
            String oldName, String newName,
            String oldUsername, String newUsername,
            String oldEmail, String newEmail,
            String oldPhone, String newPhone,
            String oldRole, String newRole) {
        String subject = "Profil adatok módosítva";

        StringBuilder changesHtml = new StringBuilder();
        changesHtml.append("<table style='width:100%; border-collapse:collapse; margin:15px 0; table-layout:fixed;'>");
        changesHtml.append("<tr style='background-color:#f0c040; color:#1a1a2e;'>");
        changesHtml.append("<th style='padding:8px; text-align:left; border:1px solid #333; width:25%;'>Mező</th>");
        changesHtml.append("<th style='padding:8px; text-align:left; border:1px solid #333; width:37%; word-break:break-all;'>Régi érték</th>");
        changesHtml.append("<th style='padding:8px; text-align:left; border:1px solid #333; width:37%; word-break:break-all;'>Új érték</th>");
        changesHtml.append("</tr>");

        addChangeRow(changesHtml, "Név", oldName, newName);
        addChangeRow(changesHtml, "Felhasználónév", oldUsername, newUsername);
        addChangeRow(changesHtml, "Email", oldEmail, newEmail);
        addChangeRow(changesHtml, "Telefon", oldPhone, newPhone);
        addChangeRow(changesHtml, "Szerepkör", translateRole(oldRole), translateRole(newRole));

        changesHtml.append("</table>");

        String html = buildEmailTemplate(
                "Profil adatok módosítva",
                "<p>Kedves " + userName + "!</p>"
                + "<p>A profilodban az alábbi módosítások történtek:</p>"
                + changesHtml.toString()
                + "<p style='color:#888; font-size:12px; margin-top:20px;'>"
                + "Ha nem te végezted ezt a módosítást, kérjük azonnal vedd fel velünk a kapcsolatot!</p>"
        );

        sendEmail(toEmail, subject, html);

        if (oldEmail != null && !oldEmail.equals(newEmail)) {
            sendEmail(oldEmail, "Figyelmeztetés: Email cím megváltoztatva",
                    buildEmailTemplate(
                            "Email cím módosítva",
                            "<p>Kedves " + oldName + "!</p>"
                            + "<p>A fiókodhoz tartozó email cím megváltozott:</p>"
                            + "<p><strong>Régi email:</strong> " + oldEmail + "</p>"
                            + "<p><strong>Új email:</strong> " + newEmail + "</p>"
                            + "<p style='color:#ff6b6b;'>Ha nem te végezted ezt a módosítást, "
                            + "kérjük azonnal vedd fel velünk a kapcsolatot!</p>"
                    )
            );
        }
    }

    // Jelszó változtatás értesítő email
    public void sendPasswordChangedEmail(String toEmail, String userName) {
        String subject = "Jelszavad megváltozott";
        String html = buildEmailTemplate(
                "Jelszó megváltozott",
                "<p>Kedves " + userName + "!</p>"
                + "<p>A jelszavad megváltozott.</p>"
                + "<p style='color:#888; font-size:12px; margin-top:20px;'>Ha nem te végezted ezt a módosítást, "
                + "kérjük azonnal vedd fel velünk a kapcsolatot!</p>"
        );
        sendEmail(toEmail, subject, html);
    }
// Jelszó visszaállítás email (Forgot Password)

    public void sendPasswordResetEmail(String toEmail, String userName, String resetToken) {
        String subject = "Jelszó visszaállítás";
        String resetLink = "http://localhost:5500/reset-password.html?token=" + resetToken;
        String html = buildEmailTemplate(
                "Jelszó visszaállítás",
                "<p>Kedves " + userName + "!</p>"
                + "<p>Jelszó visszaállítási kérelmet kaptunk a fiókodhoz.</p>"
                + "<p>Kattints az alábbi gombra a jelszavad visszaállításához:</p>"
                + "<p style='text-align:center; margin:25px 0;'>"
                + "<a href='" + resetLink + "' style='background-color:#f0c040; color:#1a1a2e; "
                + "padding:14px 35px; text-decoration:none; border-radius:8px; font-weight:bold; display:inline-block;'>"
                + "Jelszó visszaállítása</a></p>"
                + "<p style='color:#888; font-size:12px;'>Ez a link <strong>1 órán belül</strong> lejár.</p>"
                + "<p style='color:#888; font-size:12px; margin-top:15px;'>Ha nem te kérted a jelszó visszaállítást, "
                + "nyugodtan hagyd figyelmen kívül ezt az emailt.</p>"
        );
        sendEmail(toEmail, subject, html);
    }

    // Értékelés visszaigazoló email
    public void sendReviewConfirmationEmail(String toEmail, String userName,
            int orderId, int rating, String comment,
            String restaurantName, List<String> dishNames) {
        String subject = "Értékelés rögzítve - " + restaurantName;

        // Csillagok megjelenítése
        StringBuilder stars = new StringBuilder();
        for (int i = 0; i < 5; i++) {
            stars.append(i < rating ? "★" : "☆");
        }

        // Értékelés címke
        String ratingLabel;
        switch (rating) {
            case 1:
                ratingLabel = "Borzalmas";
                break;
            case 2:
                ratingLabel = "Rossz";
                break;
            case 3:
                ratingLabel = "Elmegy";
                break;
            case 4:
                ratingLabel = "Jó";
                break;
            case 5:
                ratingLabel = "Tökéletes";
                break;
            default:
                ratingLabel = "Ismeretlen";
                break;
        }

        // Rendelt ételek listája
        StringBuilder dishesHtml = new StringBuilder();
        if (dishNames != null && !dishNames.isEmpty()) {
            dishesHtml.append("<div style='background-color:#2a2a3e; padding:10px 15px; border-radius:8px; margin:10px 0;'>");
            dishesHtml.append("<p style='color:#f0c040; margin:0 0 5px 0; font-weight:bold;'>Rendelt ételek:</p>");
            for (String dish : dishNames) {
                dishesHtml.append("<p style='color:#e0e0e0; margin:2px 0; padding-left:10px;'>🍽️ ").append(dish).append("</p>");
            }
            dishesHtml.append("</div>");
        }

        String commentHtml = "";
        if (comment != null && !comment.isEmpty()) {
            commentHtml = "<div style='background-color:#2a2a3e; padding:10px 15px; border-radius:8px; margin:10px 0; border-left:3px solid #f0c040;'>"
                    + "<p style='color:#888; margin:0 0 5px 0; font-size:12px;'>Üzeneted:</p>"
                    + "<p style='color:#e0e0e0; margin:0; font-style:italic;'>\"" + comment + "\"</p>"
                    + "</div>";
        }

        String html = buildEmailTemplate(
                "Értékelés rögzítve",
                "<p>Kedves " + userName + "!</p>"
                + "<p>Köszönjük az értékelésed! Az alábbi értékelést rögzítettük:</p>"
                + "<div style='background-color:#16213e; padding:15px; border-radius:8px; margin:15px 0; text-align:center;'>"
                + "<p style='color:#e0e0e0; margin:5px 0;'><strong>Étterem:</strong> " + restaurantName + "</p>"
                + "<p style='color:#e0e0e0; margin:5px 0;'><strong>Rendelés:</strong> #" + orderId + "</p>"
                + "<p style='font-size:32px; margin:10px 0; color:#f0c040;'>" + stars.toString() + "</p>"
                + "<p style='color:#f0c040; font-size:18px; font-weight:bold; margin:5px 0;'>" + ratingLabel + " (" + rating + "/5)</p>"
                + "</div>"
                + dishesHtml.toString()
                + commentHtml
                + "<p style='color:#888; font-size:12px; margin-top:20px;'>Az értékelésed segít másoknak a választásban. Köszönjük!</p>"
        );
        sendEmail(toEmail, subject, html);
    }

    //segéd eljárások
    private void addChangeRow(StringBuilder sb, String field, String oldVal, String newVal) {
        if (oldVal == null) {
            oldVal = "-";
        }
        if (newVal == null) {
            newVal = "-";
        }
        boolean changed = !oldVal.equals(newVal);

        sb.append("<tr style='background-color:").append(changed ? "#2a3a2e" : "#2a2a3e").append(";'>");
        sb.append("<td style='padding:8px; border:1px solid #333; color:#e0e0e0; font-weight:bold;'>").append(field).append("</td>");
        sb.append("<td style='padding:8px; border:1px solid #333; color:").append(changed ? "#ff6b6b" : "#888").append("; word-break:break-all;'>").append(oldVal).append("</td>");
        sb.append("<td style='padding:8px; border:1px solid #333; color:").append(changed ? "#4ecca3" : "#888").append("; font-weight:").append(changed ? "bold" : "normal").append("; word-break:break-all;'>").append(newVal).append("</td>");
        sb.append("</tr>");
    }

    private String formatPrice(BigDecimal price) {
        if (price == null) {
            return "0 Ft";
        }
        return String.format("%,.0f Ft", price);
    }

    private String translatePaymentMethod(String method) {
        if (method == null) {
            return "Ismeretlen";
        }
        switch (method) {
            case "card":
                return "Bankkártya";
            case "cash":
                return "Készpénz";
            case "paypal":
                return "PayPal";
            default:
                return method;
        }
    }

    private String translateRole(String role) {
        if (role == null) {
            return "-";
        }
        switch (role) {
            case "customer":
                return "Vásárló";
            case "admin":
                return "Admin";
            case "restaurant_owner":
                return "Étterem tulajdonos";
            default:
                return role;
        }
    }

    private String buildEmailTemplate(String title, String bodyContent) {
        return "<!DOCTYPE html>"
                + "<html><head><meta charset='UTF-8'></head>"
                + "<body style='margin:0; padding:0; background-color:#0f0f1a; font-family:Arial, sans-serif;'>"
                + "<div style='max-width:600px; margin:0 auto; background-color:#1a1a2e; border-radius:12px; overflow:hidden; margin-top:20px; margin-bottom:20px;'>"
                // Header
                + "<div style='background-color:#f0c040; padding:20px; text-align:center;'>"
                + "<h1 style='color:#1a1a2e; margin:0; font-size:24px;'>KLSZ Faloda</h1>"
                + "</div>"
                // Tartalom
                + "<div style='padding:30px; color:#e0e0e0;'>"
                + "<h2 style='color:#f0c040; margin-top:0;'>" + title + "</h2>"
                + bodyContent
                + "</div>"
                // Footer
                + "<div style='background-color:#16213e; padding:15px; text-align:center; border-top:2px solid #f0c040;'>"
                + "<p style='color:#888; font-size:12px; margin:0;'>KLSZ Faloda - Pécs legjobb ételrendelő platformja</p>"
                + "<p style='color:#666; font-size:11px; margin:5px 0 0;'>Ez egy automatikus értesítés, kérjük ne válaszolj erre az emailre.</p>"
                + "</div>"
                + "</div></body></html>";
    }
}

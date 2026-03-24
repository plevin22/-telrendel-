/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.vizsgaremek1.controller;

/**
 *
 * @author djhob
 */
import java.util.Set;
import javax.ws.rs.core.Application;

@javax.ws.rs.ApplicationPath("webresources")
public class ApplicationConfig extends Application {

    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> resources = new java.util.HashSet<>();
        addRestResourceClasses(resources);
        return resources;
    }

    /**
     
Do not modify addRestResourceClasses() method. It is automatically
populated with all resources defined in the project. If required, comment
out calling this method in getClasses().*/
private void addRestResourceClasses(Set<Class<?>> resources) {
    resources.add(com.mycompany.vizsgaremek1.config.CorsFilter.class);
        resources.add(com.mycompany.vizsgaremek1.controller.DeliveryController.class);
        resources.add(com.mycompany.vizsgaremek1.controller.DishesController.class);
        resources.add(com.mycompany.vizsgaremek1.controller.EmailController.class);
        resources.add(com.mycompany.vizsgaremek1.controller.OrderItemsController.class);
        resources.add(com.mycompany.vizsgaremek1.controller.OrdersController.class);
        resources.add(com.mycompany.vizsgaremek1.controller.PasswordResetTokenController.class);
        resources.add(com.mycompany.vizsgaremek1.controller.PaymentsController.class);
        resources.add(com.mycompany.vizsgaremek1.controller.RestaurantsController.class);
        resources.add(com.mycompany.vizsgaremek1.controller.ReviewsController.class);
        resources.add(com.mycompany.vizsgaremek1.controller.UsersController.class);
}

}

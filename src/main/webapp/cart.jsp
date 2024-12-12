<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="Models.Product" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Votre Panier</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container my-4">
        <h1 class="text-center mb-4">Votre Panier</h1>

        <% 
            // Get the cart details and total amount from the request attributes
            Map<Product, Integer> cartDetails = (Map<Product, Integer>) request.getAttribute("cartDetails");
            Double totalAmount = (Double) request.getAttribute("totalAmount");
            
            if (cartDetails == null || cartDetails.isEmpty()) {
        %>
            <p class="text-center">Votre panier est vide.</p>
        <% 
            } else { 
        %>
            <table class="table">
                <thead>
                    <tr>
                        <th>Produit</th>
                        <th>Quantité</th>
                        <th>Prix Unitaire</th>
                        <th>Total</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        // Loop through the cart details and display each product
                        for (Map.Entry<Product, Integer> entry : cartDetails.entrySet()) {
                            Product product = entry.getKey();
                            Integer quantity = entry.getValue();
                    %>
                        <tr>
                            <td><%= product.getNom() %></td>  <!-- Product name -->
                            <td><%= quantity %></td>  <!-- Quantity -->
                            <td><%= product.getPrix() %></td>  <!-- Unit price -->
                            <td><%= quantity * product.getPrix() %></td>  <!-- Total price for this product -->
                            <td>
                                <form action="CartServlet" method="POST" style="display:inline;">
                                    <input type="hidden" name="action" value="removeFromCart">
                                    <input type="hidden" name="productId" value="<%= product.getId() %>">
                                    <button type="submit" class="btn btn-danger">Supprimer</button>
                                </form>
                            </td>
                        </tr>
                    <% 
                        } 
                    %>
                </tbody>
            </table>

            <div class="text-end">
                <h3>Total: <%= totalAmount %> €</h3>
            </div>

            <a href="CheckoutServlet" class="btn btn-success btn-lg">Passer à la caisse</a>
        <% 
            } 
        %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

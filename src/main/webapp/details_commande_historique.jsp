<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Détails de la Commande</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css">
</head>
<body>

       <% String message = (String) request.getAttribute("message"); %>
<div class="container my-5">
    <% if (message != null) { %>
        <div class="alert alert-info">
            <%= message %>
        </div>
    <% } %>
    <!-- Afficher les détails de la commande uniquement si la commande existe -->
    <% if (request.getAttribute("commande") != null) { %>
        <h1 class="mb-4">Détails de la Commande</h1>
        <%
            Map<String, String> commande = (Map<String, String>) request.getAttribute("commande");
            List<Map<String, String>> produits = (List<Map<String, String>>) request.getAttribute("produits");
        %>
        <h3>Commande N°: <%= commande.get("id") %></h3>
        <p>Date : <%= commande.get("date") %></p>
        <p>Statut : <%= commande.get("statut") %></p>

        <h4>Produits</h4>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Nom</th>
                    <th>Prix Unitaire</th>
                    <th>Quantité</th>
                    <th>Prix Total</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, String> produit : produits) { %>
                    <tr>
                        <td><%= produit.get("nom") %></td>
                        <td><%= produit.get("prix_unitaire") %></td>
                        <td><%= produit.get("quantite") %></td>
                        <td><%= produit.get("prix_total") %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>

</body>
</html>

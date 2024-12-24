<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Historique des Commandes</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css">
</head>
<style>
.navbar .nav-link, .navbar .navbar-brand {
        font-size: 1.2rem; /* Taille uniforme */
        color: white !important; /* Couleur blanche */
        transition: color 0.3s ease, transform 0.3s ease;
    }
    .navbar .nav-link:hover, .navbar .navbar-brand:hover {
        color: #00b4d8 !important; /* Couleur au survol */
        transform: scale(1.1); /* Effet de zoom */
    }
    .navbar-toggler {
        border-color: white; /* Couleur blanche pour le bouton burger */
    }
    .navbar-toggler-icon {
        background-color: white; /* Icône blanche pour le bouton burger */
    }
</style>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="userDashboard.jsp">Home</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
            <li class="nav-item">
                        <a class="nav-link" href="panier.jsp">Panier</a>
                    </li>
                <li class="nav-item">
                    <a class="nav-link" href="LogoutServlet">Déconnexion</a>
                </li>
                
            </ul>
        </div>
    </div>
</nav>
    <div class="container my-5">
        <h1 class="mb-4">Historique des Commandes</h1>

        <%
            List<Map<String, String>> commandes = (List<Map<String, String>>) request.getAttribute("commandes");
            if (commandes == null || commandes.isEmpty()) {
        %>
            <p>Vous n'avez pas encore passé de commandes.</p>
        <% } else { %>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Numéro de commande</th>
                        <th>Date</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, String> commande : commandes) { %>
                        <tr>
                            <td><%= commande.get("id") %></td>
                            <td><%= commande.get("date") %></td>
                            <td><%= commande.get("statut") %></td>
                            <td>
                                <a href="DetailsCommandeHistoriqueServlet?id=<%= commande.get("id") %>" class="btn btn-primary btn-sm">Voir les détails</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</body>
</html>

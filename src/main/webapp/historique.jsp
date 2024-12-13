<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Historique des Commandes</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css">
</head>
<body>
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

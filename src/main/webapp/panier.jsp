<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mon Panier</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
   <style>
    .navbar .nav-link, .navbar .navbar-brand {
        font-size: 1.2rem; /* Définir une taille uniforme pour les deux */
        color: white !important;
        transition: color 0.3s ease, transform 0.3s ease;
    }
    .navbar .nav-link:hover, .navbar .navbar-brand:hover {
        color: #00b4d8 !important; /* Changer la couleur au survol */
        transform: scale(1.1); /* Effet de zoom */
    }
</style>
   
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="userDashboard.jsp">Home</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                            <li class="nav-item me-3">
                    <a class="nav-link" href="HistoriqueCommandeServlet">Historique commandes</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="LogoutServlet">Déconnexion</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

    <div class="container py-5">
        <h1 class="mb-4">Mon Panier</h1>

        <% 
            // Récupérer le panier depuis la session
            List<String[]> panier = (List<String[]>) session.getAttribute("panier");

            // Vérifier si l'utilisateur est connecté
            Integer utilisateurId = (Integer) session.getAttribute("utilisateurId");
            if (utilisateurId == null) {
        %>
            <p>Veuillez <a href="login.jsp">vous connecter</a> pour accéder à votre panier.</p>
        <% } else if (panier == null || panier.isEmpty()) { %>
            <p>Votre panier est vide.</p>
        <% } else {
                // Calculer le total du panier
                double total = 0.0;
        %>

        <form action="MettreAJourPanierServlet" method="POST">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Produit</th>
                        <th>Prix Unitaire</th>
                        <th>Quantité</th>
                        <th>Total</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        // Affichage des produits du panier
                        for (String[] produit : panier) {
                            String productId = produit[0];  // ID du produit
                            String nom = produit[1];  // nom
                            String prixStr = produit[2].replace(",", ".");
                            double prix = Double.parseDouble(prixStr);  // prix
                            int quantite = Integer.parseInt(produit[3]);  // quantité
                            double totalProduit = prix * quantite;  // total pour ce produit
                            total += totalProduit;
                    %>
                    <tr>
                        <td><%= nom %></td>
                        <td><%= String.format("%.2f", prix) %> €</td>
                        <td>
                            <input type="number" name="quantite_<%= productId %>" value="<%= quantite %>" min="1" class="form-control" />
                        </td>
                        <td><%= String.format("%.2f", totalProduit) %> €</td>
                        <td>
                            <form action="RetirerDuPanierServlet" method="POST" style="display:inline;">
                                <input type="hidden" name="id" value="<%= productId %>" />
                                <button type="submit" class="btn btn-danger btn-sm">
                                    <i class="fas fa-trash-alt"></i> Retirer
                                </button>
                            </form>
                        </td>
                    </tr>
                    <% 
                        }
                    %>
                </tbody>
            </table>

            <!-- Affichage du total -->
            <div class="d-flex justify-content-between">
                <h3>Total : <%= String.format("%.2f", total) %> €</h3>
                <button type="submit" class="btn btn-primary">Mettre à jour le panier</button>
            </div>
        </form>

        <form action="ValiderCommandeServlet" method="POST" class="mt-3">
            <button type="submit" class="btn btn-success">Valider la commande</button>
        </form>

        <% 
            }
        %>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
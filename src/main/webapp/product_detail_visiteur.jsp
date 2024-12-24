<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Détails du Produit</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    
    
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
    .quantity-input {
        width: 80px; /* Ajustez la largeur selon vos besoins */
    }
    
</style>
    
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="home.jsp">Home</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
               
                <li class="nav-item">
                    <a class="nav-link" href="Connexion.jsp">Se Connecter</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

    <div class="container py-5">
        <h1 class="mb-4">Détails du Produit</h1>
        <div class="row">
            <% 
                String url = "jdbc:postgresql://localhost:5432/ecommerce";
                String username = "postgres";
                String password = "123456";
                String productId = request.getParameter("id");

                if (productId != null) {
                    try {
                        Class.forName("org.postgresql.Driver");
                        Connection conn = DriverManager.getConnection(url, username, password);

                        String sql = "SELECT p.nom, p.description, p.prix, p.image, p.stock " +
                                     "FROM public.products p WHERE p.id = ?";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setInt(1, Integer.parseInt(productId));
                        ResultSet rs = ps.executeQuery();

                        if (rs.next()) {
                            String name = rs.getString("nom");
                            String description = rs.getString("description");
                            double price = rs.getDouble("prix");
                            String image = rs.getString("image");
                            int stock = rs.getInt("stock");
                            String fullImagePath = request.getContextPath() + "/" + image;
            %>
            <div class="col-md-6">
                <img src="<%= fullImagePath %>" alt="<%= name %>" class="product-img rounded w-100 h-auto" />
            </div>
            <div class="col-md-6">
                <h2 class="mb-3"><%= name %></h2>
                <p><strong>Description :</strong> <%= description %></p>
                <p><strong>Prix :</strong> <%= String.format("%.2f", price) %> €</p>
                <p><strong>Stock :</strong> <%= stock %> unités</p>
                
                <form action="AjouterAuPanierServlet" method="GET" class="d-flex align-items-center gap-2">
    <input type="hidden" name="id" value="<%= productId %>" />
    <input type="hidden" name="nom" value="<%= name %>" />
    <input type="hidden" name="prix" value="<%= String.format("%.2f", price) %>" />

    <label for="quantity" class="me-2">Quantité :</label>
    <input type="number" id="quantity" name="quantite" class="form-control quantity-input w-auto" value="1" min="1" max="<%= stock %>" required />

    <button type="submit" class="btn btn-success d-flex align-items-center gap-2">
        <i class="bi bi-cart"></i> Ajouter au panier
    </button>
</form>
                

            </div>
            <% 
                        } else {
                            out.println("<p class='text-danger'>Produit non trouvé.</p>");
                        }
                        rs.close();
                        ps.close();
                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p class='text-danger'>Erreur lors de la récupération des détails du produit.</p>");
                    }
                } else {
                    out.println("<p class='text-danger'>ID du produit manquant.</p>");
                }
            %>
        </div>
    </div>
</body>
</html>

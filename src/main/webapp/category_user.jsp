<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Produits de la catégorie</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card-img-top {
            height: 240px;
            object-fit: cover;
        }
        .product-container {
            margin-top: 30px;
        }
        /* Grid container for products */
        .product-container .row {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }
        /* Style for each card */
        .product-container .card {
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .product-container .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
        }
        .product-container .card-body {
            text-align: center;
        }
        .navbar {
        margin-bottom: 20px;
    }
    .navbar .nav-link, .navbar .navbar-brand {
        color: white !important;
        transition: color 0.3s ease, transform 0.3s ease;
    }
    .navbar .nav-link:hover, .navbar .navbar-brand:hover {
        color: #00b4d8 !important; /* Changer la couleur au survol */
        transform: scale(1.1); /* Effet de zoom */
    }
    .dropdown-menu .dropdown-item {
        color: #333 !important;
        transition: background-color 0.3s ease, color 0.3s ease;
    }
    .dropdown-menu .dropdown-item:hover {
        background-color: #007bff !important; /* Fond bleu au survol */
        color: white !important;
    }
    </style>
</head>
<body>
    <!-- Navbar for User Homepage -->
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
    <div class="container product-container">

        <div class="row">
            <%
                // Get the category ID from the URL
                String categoryId = request.getParameter("id");

                // Check if categoryId is valid
                if (categoryId != null && !categoryId.isEmpty()) {
                    // Database connection details declared once here
                    String url = "jdbc:postgresql://localhost:5432/ecommerce";
                    String username = "postgres";
                    String password = "123456";
                    
                    try {
                        Class.forName("org.postgresql.Driver"); 
                        Connection conn = DriverManager.getConnection(url, username, password);

                        // SQL to get products based on the category_id
                        String sql = "SELECT id, nom, prix, image FROM public.products WHERE categorie_id = ?";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setInt(1, Integer.parseInt(categoryId));  // Set the category ID
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                            int productId = rs.getInt("id");
                            String name = rs.getString("nom");
                            double price = rs.getDouble("prix");
                            String imagePath = rs.getString("image");

                            // Build the full image path
                            String fullImagePath = request.getContextPath() + "/" + imagePath;
            %>
                            <div class="col">
                                <div class="card h-100 shadow-sm">
                                    <a href="product_detail_visiteur.jsp?id=<%= productId %>" class="text-decoration-none">
                                        <img src="<%= fullImagePath %>" class="card-img-top" alt="<%= name %>">
                                        <div class="card-body">
                                            <h5 class="card-title text-dark"><%= name %></h5>
                                            <h6 class="card-text text-primary"><%= String.format("%.2f", price) %> €</h6>
                                        </div>
                                    </a>
                                </div>
                            </div>
            <%
                        }
                        rs.close();
                        ps.close();
                    } catch (SQLException | ClassNotFoundException e) {
                        e.printStackTrace(); // Print full exception stack trace
                        out.print("Erreur de connexion à la base de données: " + e.getMessage());
                    }
                } else {
                    out.print("<p>Aucune catégorie sélectionnée.</p>");
                }
            %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
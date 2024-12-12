<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Liste des produits</title>
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
        .btn-custom {
            width: 100%;
        }
    </style>
</head>
<body>
    <!-- Navbar for User Homepage -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="UserHomepage.jsp">Accueil</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="CartServlet?action=viewCart">Panier</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="CategoriesServlet">Catégories</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="LogoutServlet">Déconnexion</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container product-container">
        <h1 class="text-center mb-4">Liste des Produits</h1>

        <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4">
            <%
                String url = "jdbc:postgresql://localhost:5432/ecommerce";
                String username = "postgres";
                String password = "admin123";
                
                try {
                    Class.forName("org.postgresql.Driver"); 
                    Connection conn = DriverManager.getConnection(url, username, password);

                    String sql = "SELECT id, nom, prix, image FROM public.products";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        int productId = rs.getInt("id");
                        String name = rs.getString("nom");
                        double price = rs.getDouble("prix");
                        String imagePath = rs.getString("image");

                        // Construire l'URL complète pour l'image
                        String fullImagePath = request.getContextPath() + "/" + imagePath;
            %>
                        <div class="col">
                            <div class="card h-100 shadow-sm">
                                <a href="product_detail.jsp?id=<%= productId %>" class="text-decoration-none">
                                    <img src="<%= fullImagePath %>" class="card-img-top" alt="<%= name %>">
                                    <div class="card-body text-center">
                                        <h5 class="card-title text-dark"><%= name %></h5>
                                        <h6 class="card-text text-primary"><%= String.format("%.2f", price) %> €</h6>
                                    </div>
                                </a>
                                <div class="d-flex justify-content-center p-3">
                                    <!-- Add to cart button -->
                                    <form action="CartServlet" method="POST">
    <input type="hidden" name="action" value="addToCart">
    <input type="hidden" name="productId" value="<%= productId %>">
    <!-- Add an input field for quantity -->
    <input type="number" name="quantity" value="1" min="1" class="form-control" style="width: 80px;">
    <button type="submit" class="btn btn-primary btn-custom">Ajouter au Panier</button>
</form>
                                </div>
                            </div>
                        </div>
            <%
                    }
                    rs.close();
                    ps.close();
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace();
                    out.print("Erreur de connexion à la base de données.");
                }
            %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

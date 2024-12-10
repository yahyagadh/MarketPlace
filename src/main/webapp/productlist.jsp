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
    <div class="container product-container">
        <h1 class="text-center mb-4">Liste des Produits</h1>
        
        <!-- Bouton pour ajouter un produit -->
        <div class="text-center mb-4">
            <a href="add_product.jsp" class="btn btn-primary btn-lg">Ajouter un nouveau produit</a>
        </div>

        <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4">
            <%
                String url = "jdbc:postgresql://localhost:5432/ecommerce";
                String username = "postgres";
                String password = "123456";
                
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
                                    <div class="d-flex justify-content-between p-3">
                                        <a href="editproduct.jsp?id=<%= productId %>" class="btn btn-warning btn-custom">Modifier</a>
                                        <a href="ProductServlet?action=delete&id=<%= productId %>" class="btn btn-danger btn-custom" onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce produit ?')">Supprimer</a>
                                    </div>
                                </a>
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

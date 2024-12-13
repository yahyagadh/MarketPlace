<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession, jakarta.servlet.http.HttpServletResponse, jakarta.servlet.*" %>
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
        .out-of-stock-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 0, 0, 0.5);
            color: white;
            font-size: 1.5rem;
            font-weight: bold;
            text-align: center;
            line-height: 240px; /* Align text vertically */
        }
        .card {
            position: relative;
        }
        .card.out-of-stock {
            pointer-events: none; /* Disable interactions */
        }
    </style>
</head>
<body>
    <%-- Vérifier si l'utilisateur est connecté --%>
    <%
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Connexion.jsp");
            return;
        }
    %>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="UserHomepage.jsp">Accueil</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="panier.jsp">Panier</a></li>
                    <li class="nav-item"><a class="nav-link" href="HistoriqueCommandeServlet">Historique</a></li>
                    <li class="nav-item"><a class="nav-link" href="LogoutServlet">Se déconnecter</a>
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
                String password = "123456";
                
                try {
                    Class.forName("org.postgresql.Driver"); 
                    Connection conn = DriverManager.getConnection(url, username, password);

                    String sql = "SELECT id, nom, prix, image, stock FROM public.products";  // Inclure le stock
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        int productId = rs.getInt("id");
                        String name = rs.getString("nom");
                        double price = rs.getDouble("prix");
                        String imagePath = rs.getString("image");
                        int stock = rs.getInt("stock");

                        // Build the full image path
                        String fullImagePath = request.getContextPath() + "/" + imagePath;

                        // Check stock availability
                        boolean outOfStock = stock <= 0;
            %>
                        <div class="col">
                            <div class="card h-100 shadow-sm <%= outOfStock ? "out-of-stock" : "" %>">
                                <% if (!outOfStock) { %>
                                    <a href="product_detail_user.jsp?id=<%= productId %>" class="text-decoration-none">
                                <% } %>
                                    <img src="<%= fullImagePath %>" class="card-img-top" alt="<%= name %>">
                                    <div class="card-body text-center">
                                        <h5 class="card-title text-dark"><%= name %></h5>
                                        <h6 class="card-text text-primary"><%= String.format("%.2f", price) %> €</h6>
                                    </div>
                                <% if (!outOfStock) { %>
                                    </a>
                                <% } %>
                                <% if (outOfStock) { %>
                                    <div class="out-of-stock-overlay">Rupture de stock</div>
                                <% } %>
                            </div>
                        </div>
            <%
                    }
                    rs.close();
                    ps.close();
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace();
                    out.print("Erreur de connexion à la base de données: " + e.getMessage());
                }
            %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

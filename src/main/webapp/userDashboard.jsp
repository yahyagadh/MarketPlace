<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession, jakarta.servlet.http.HttpServletResponse, jakarta.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des produits</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
    body {
        background-color: #f1f1f1;
        font-family: 'Arial', sans-serif;
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
    .product-container {
        margin-top: 30px;
    }
    .card {
        border: none;
        border-radius: 10px;
        overflow: hidden;
        transition: transform 0.3s, box-shadow 0.3s;
    }
    .card:hover {
        transform: scale(1.05);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }
    .card-img-top {
        height: 200px;
        object-fit: cover;
    }
    .out-of-stock-overlay {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(255, 0, 0, 0.6);
        color: white;
        font-size: 1.2rem;
        font-weight: bold;
        text-align: center;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .card-title {
        font-size: 1.1rem;
        font-weight: bold;
        color: #333;
    }
    .card-text {
        font-size: 1rem;
        color: #007bff;
    }
    footer {
        background-color: #343a40;
        color: white;
        text-align: center;
        padding: 10px 0;
        position: fixed;
        bottom: 0;
        width: 100%;
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
    <nav class="navbar navbar-expand-lg navbar-light bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="userDashboard.jsp">Home</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item me-3">
                    <a class="nav-link" href="panier.jsp">Panier</a>
                </li>
                <li class="nav-item dropdown me-3">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        Catégories
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <% 
                            // Récupération des catégories depuis la base de données
                            String db_url = "jdbc:postgresql://localhost:5432/ecommerce";
                            String db_username = "postgres";
                            String db_password = "123456";

                            try {
                                Class.forName("org.postgresql.Driver");
                                Connection conn = DriverManager.getConnection(db_url, db_username, db_password);

                                String sql = "SELECT id, nom FROM public.categorie";
                                PreparedStatement ps = conn.prepareStatement(sql);
                                ResultSet rs = ps.executeQuery();

                                while (rs.next()) {
                                    int categoryId = rs.getInt("id");
                                    String categoryName = rs.getString("nom");
                        %>
                                    <li><a class="dropdown-item" href="category.jsp?id=<%= categoryId %>"><%= categoryName %></a></li>
                        <% 
                                }
                                rs.close();
                                ps.close();
                            } catch (SQLException | ClassNotFoundException e) {
                                e.printStackTrace();
                                out.print("Erreur de connexion à la base de données: " + e.getMessage());
                            }
                        %>
                    </ul>
                </li>
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

                    String sql = "SELECT id, nom, prix, image, stock FROM public.products";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        int productId = rs.getInt("id");
                        String name = rs.getString("nom");
                        double price = rs.getDouble("prix");
                        String imagePath = rs.getString("image");
                        int stock = rs.getInt("stock");

                        String fullImagePath = request.getContextPath() + "/" + imagePath;
                        boolean outOfStock = stock <= 0;
            %>
                        <div class="col">
                            <div class="card h-100 position-relative <%= outOfStock ? "out-of-stock" : "" %>">
                                <% if (!outOfStock) { %>
                                    <a href="product_detail_user.jsp?id=<%= productId %>" class="text-decoration-none">
                                <% } %>
                                    <img src="<%= fullImagePath %>" class="card-img-top" alt="<%= name %>">
                                    <div class="card-body text-center">
                                        <h5 class="card-title"><%= name %></h5>
                                        <h6 class="card-text"><%= String.format("%.2f", price) %> €</h6>
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
